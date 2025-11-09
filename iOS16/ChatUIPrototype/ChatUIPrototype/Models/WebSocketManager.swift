import Foundation
import Combine

// MARK: - WebSocket Manager Protocol

protocol WebSocketManagerDelegate: AnyObject {
    func webSocketDidConnect(_ manager: WebSocketManager)
    func webSocketDidDisconnect(_ manager: WebSocketManager, reason: String?)
    func webSocket(_ manager: WebSocketManager, didReceiveMessage message: IncomingMessage)
    func webSocket(_ manager: WebSocketManager, didReceiveEvent event: WebSocketEvent)
    func webSocket(_ manager: WebSocketManager, didEncounterError error: WebSocketError)
}

// MARK: - WebSocket Manager

class WebSocketManager: NSObject, ObservableObject {
    // MARK: - Published Properties
    
    @Published private(set) var connectionState: WebSocketConnectionState = .disconnected
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var typingUsers: Set<String> = []
    @Published private(set) var onlineUsers: [RemoteUser] = []
    
    // MARK: - Properties
    
    private let configuration: WebSocketConfiguration
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession!
    private var heartbeatTimer: Timer?
    private var reconnectTimer: Timer?
    private var reconnectAttempts: Int = 0
    
    weak var delegate: WebSocketManagerDelegate?
    
    // MARK: - Combine
    
    private var cancellables = Set<AnyCancellable>()
    let messagePublisher = PassthroughSubject<IncomingMessage, Never>()
    let eventPublisher = PassthroughSubject<WebSocketEvent, Never>()
    let errorPublisher = PassthroughSubject<WebSocketError, Never>()
    
    // MARK: - Initialization
    
    init(configuration: WebSocketConfiguration = .defaultConfiguration) {
        self.configuration = configuration
        super.init()
        setupURLSession()
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Setup
    
    private func setupURLSession() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = configuration.messageTimeout
        urlSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: .main)
    }
    
    // MARK: - Connection Management
    
    func connect() {
        guard connectionState != .connected && connectionState != .connecting else { return }

        connectionState = .connecting
        webSocketTask = urlSession.webSocketTask(with: configuration.url)
        webSocketTask?.resume()
        receiveMessage()
        startHeartbeat()
    }
    
    func disconnect() {
        stopHeartbeat()
        stopReconnectTimer()
        
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        
        connectionState = .disconnected
        isConnected = false
        delegate?.webSocketDidDisconnect(self, reason: "Manual disconnect")
        eventPublisher.send(.disconnected(reason: "Manual disconnect"))
    }
    
    private func reconnect() {
        guard reconnectAttempts < configuration.maxReconnectAttempts else {
            connectionState = .failed
            return
        }
        
        connectionState = .reconnecting
        reconnectAttempts += 1
        
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: configuration.reconnectInterval, repeats: false) { [weak self] _ in
            self?.connect()
        }
    }
    
    // MARK: - Message Handling
    
    func sendMessage(_ message: OutgoingTextMessage) async {
        guard isConnected else {
            errorPublisher.send(.connectionFailed)
            return
        }
        
        do {
            let data = try JSONEncoder().encode(message)
            let message = URLSessionWebSocketTask.Message.data(data)
            try await webSocketTask?.send(message)
        } catch {
            if error is EncodingError {
                handleError(.encodingFailed)
            } else {
                handleError(.serverError(error.localizedDescription))
            }
        }
    }
    
    func sendImageMessage(_ message: OutgoingImageMessage) async {
        guard isConnected else {
            errorPublisher.send(.connectionFailed)
            return
        }
        
        do {
            let data = try JSONEncoder().encode(message)
            let message = URLSessionWebSocketTask.Message.data(data)
            try await webSocketTask?.send(message)
        } catch {
            if error is EncodingError {
                handleError(.encodingFailed)
            } else {
                handleError(.serverError(error.localizedDescription))
            }
        }
    }
    
    func sendTypingIndicator(isTyping: Bool, userId: String, userName: String) async {
        let indicator = TypingIndicator(userId: userId, userName: userName, isTyping: isTyping)
        
        do {
            let data = try JSONEncoder().encode(indicator)
            let message = URLSessionWebSocketTask.Message.data(data)
            try await webSocketTask?.send(message)
        } catch {
            if error is EncodingError {
                handleError(.encodingFailed)
            } else {
                handleError(.serverError(error.localizedDescription))
            }
        }
    }
    
    private func receiveMessage() {
        Task {
            await receiveMessageAsync()
        }
    }
    
    private func receiveMessageAsync() async {
        guard let webSocketTask = webSocketTask else { return }
        
        do {
            while isConnected {
                let message = try await webSocketTask.receive()
                handleReceivedMessage(message)
            }
        } catch {
            handleError(.serverError(error.localizedDescription))
            reconnect()
        }
    }
    
    private func handleReceivedMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .data(let data):
            processData(data)
            
        case .string(let string):
            if let data = string.data(using: .utf8) {
                processData(data)
            }
            
        @unknown default:
            break
        }
    }
    
    private func processData(_ data: Data) {
        do {
            // First decode to get message type
            let baseMessage = try JSONDecoder().decode(BaseWebSocketMessage.self, from: data)
            
            switch baseMessage.type {
            case .message:
                let message = try JSONDecoder().decode(IncomingMessage.self, from: data)
                delegate?.webSocket(self, didReceiveMessage: message)
                messagePublisher.send(message)
                eventPublisher.send(.messageReceived(message))
                
            case .userJoined:
                let message = try JSONDecoder().decode(UserJoinedMessage.self, from: data)
                eventPublisher.send(.userJoined(message))
                
            case .userLeft:
                let message = try JSONDecoder().decode(UserLeftMessage.self, from: data)
                eventPublisher.send(.userLeft(message))
                
            case .typing, .typingStop:
                let message = try JSONDecoder().decode(TypingStatusMessage.self, from: data)
                updateTypingStatus(message)
                eventPublisher.send(.typingStatusChanged(message))
                
            case .error:
                let message = try JSONDecoder().decode(ErrorMessage.self, from: data)
                eventPublisher.send(.errorOccurred(message))
                
            case .ping:
                sendPong()
                
            case .pong:
                // Heartbeat received
                break
                
            default:
                break
            }
        } catch {
            handleError(.decodingFailed)
        }
    }
    
    private func updateTypingStatus(_ message: TypingStatusMessage) {
        if message.isTyping {
            typingUsers.insert(message.userId)
        } else {
            typingUsers.remove(message.userId)
        }
    }
    
    // MARK: - Heartbeat
    
    private func startHeartbeat() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: configuration.heartbeatInterval, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    private func sendPing() {
        Task {
            await sendPingAsync()
        }
    }
    
    private func sendPingAsync() async {
        let ping = ["type": "ping", "timestamp": Date().timeIntervalSince1970] as [String : Any]
        
        if let data = try? JSONSerialization.data(withJSONObject: ping) {
            let message = URLSessionWebSocketTask.Message.data(data)
            try? await webSocketTask?.send(message)
        }
    }
    
    private func sendPong() {
        Task {
            await sendPongAsync()
        }
    }
    
    private func sendPongAsync() async {
        let pong = ["type": "pong", "timestamp": Date().timeIntervalSince1970] as [String : Any]
        
        if let data = try? JSONSerialization.data(withJSONObject: pong) {
            let message = URLSessionWebSocketTask.Message.data(data)
            try? await webSocketTask?.send(message)
        }
    }
    
    // MARK: - Error Handling
    
    private func handleError(_ error: WebSocketError) {
        delegate?.webSocket(self, didEncounterError: error)
        errorPublisher.send(error)
    }
    
    private func stopReconnectTimer() {
        reconnectTimer?.invalidate()
        reconnectTimer = nil
    }
}

// MARK: - URLSessionWebSocketDelegate

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        connectionState = .connected
        isConnected = true
        reconnectAttempts = 0
        
        delegate?.webSocketDidConnect(self)
        eventPublisher.send(.connected)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        let reasonString = reason.flatMap { String(data: $0, encoding: .utf8) }
        
        connectionState = .disconnected
        isConnected = false
        
        delegate?.webSocketDidDisconnect(self, reason: reasonString)
        eventPublisher.send(.disconnected(reason: reasonString))
        
        // Attempt reconnection if not manual disconnect
        if closeCode != .goingAway {
            reconnect()
        }
    }
}

// MARK: - Helper Types

private struct BaseWebSocketMessage: Decodable {
    let type: WebSocketMessageType
}
