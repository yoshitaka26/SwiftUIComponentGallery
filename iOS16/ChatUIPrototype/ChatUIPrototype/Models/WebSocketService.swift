import Foundation
import Combine
import SwiftUI

// MARK: - WebSocket Service

class WebSocketService: ObservableObject {
    // MARK: - Singleton
    
    static let shared = WebSocketService()
    
    // MARK: - Published Properties
    
    @Published private(set) var messages: [IncomingMessage] = []
    @Published private(set) var connectionState: WebSocketConnectionState = .disconnected
    @Published private(set) var typingUsers: [String: String] = [:] // userId: userName
    @Published private(set) var onlineUsers: [RemoteUser] = []
    @Published private(set) var currentRoom: ChatRoom?
    
    // MARK: - Properties
    
    private let webSocketManager: WebSocketManager
    private var cancellables = Set<AnyCancellable>()
    private let currentUserId = UUID().uuidString
    private let currentUserName = "自分"
    
    // MARK: - Message Queue (for offline support)
    
    private var messageQueue: [OutgoingTextMessage] = []
    
    // MARK: - Initialization
    
    private init(configuration: WebSocketConfiguration = .defaultConfiguration) {
        self.webSocketManager = WebSocketManager(configuration: configuration)
        setupBindings()
    }
    
    // MARK: - Setup
    
    private func setupBindings() {
        // Connection state
        webSocketManager.$connectionState
            .sink { [weak self] state in
                self?.connectionState = state
                if case .connected = state {
                    self?.flushMessageQueue()
                }
            }
            .store(in: &cancellables)
        
        // Messages
        webSocketManager.messagePublisher
            .sink { [weak self] message in
                self?.handleIncomingMessage(message)
            }
            .store(in: &cancellables)
        
        // Events
        webSocketManager.eventPublisher
            .sink { [weak self] event in
                self?.handleWebSocketEvent(event)
            }
            .store(in: &cancellables)
        
        // Typing users
        webSocketManager.$typingUsers
            .sink { [weak self] userIds in
                // In real app, fetch user names from user IDs
                self?.updateTypingUsers(userIds)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func connect() {
        webSocketManager.connect()
    }
    
    func disconnect() {
        webSocketManager.disconnect()
    }
    
    func sendTextMessage(_ text: String) {
        Task {
            await sendTextMessageAsync(text)
        }
    }
    
    private func sendTextMessageAsync(_ text: String) async {
        let message = OutgoingTextMessage(
            text: text,
            senderId: currentUserId,
            senderName: currentUserName
        )
        
        if connectionState == .connected {
            await webSocketManager.sendMessage(message)
        } else {
            // Queue message for later
            messageQueue.append(message)
        }
        
        // Add optimistic update
        let optimisticMessage = IncomingMessage(
            id: message.messageId,
            timestamp: message.timestamp,
            content: .text(text),
            senderId: currentUserId,
            senderName: currentUserName,
            senderAvatarColor: "blue"
        )
        await MainActor.run {
            messages.append(optimisticMessage)
        }
    }
    
    func sendImageMessage(_ imageData: Data) {
        Task {
            await sendImageMessageAsync(imageData)
        }
    }
    
    private func sendImageMessageAsync(_ imageData: Data) async {
        let message = OutgoingImageMessage(
            imageData: imageData,
            senderId: currentUserId,
            senderName: currentUserName
        )
        
        if connectionState == .connected {
            await webSocketManager.sendImageMessage(message)
        }
        
        // Add optimistic update
        let optimisticMessage = IncomingMessage(
            id: message.messageId,
            timestamp: message.timestamp,
            content: .image(imageData),
            senderId: currentUserId,
            senderName: currentUserName,
            senderAvatarColor: "blue"
        )
        await MainActor.run {
            messages.append(optimisticMessage)
        }
    }
    
    func startTyping() {
        Task {
            await webSocketManager.sendTypingIndicator(
                isTyping: true,
                userId: currentUserId,
                userName: currentUserName
            )
        }
    }
    
    func stopTyping() {
        Task {
            await webSocketManager.sendTypingIndicator(
                isTyping: false,
                userId: currentUserId,
                userName: currentUserName
            )
        }
    }
    
    func joinRoom(_ roomId: String) {
        // Send join room message
        let joinMessage = [
            "type": "join_room",
            "roomId": roomId,
            "userId": currentUserId,
            "userName": currentUserName
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: joinMessage) {
            // In real app, send this through WebSocket
        }
    }
    
    func leaveRoom() {
        guard let roomId = currentRoom?.id else { return }
        
        let leaveMessage = [
            "type": "leave_room",
            "roomId": roomId,
            "userId": currentUserId
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: leaveMessage) {
            // In real app, send this through WebSocket
        }
        
        currentRoom = nil
        messages.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func handleIncomingMessage(_ message: IncomingMessage) {
        // Skip if it's our own message (already added optimistically)
        guard message.senderId != currentUserId else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.messages.append(message)
        }
    }
    
    private func handleWebSocketEvent(_ event: WebSocketEvent) {
        switch event {
        case .userJoined(let message):
            handleUserJoined(message)
            
        case .userLeft(let message):
            handleUserLeft(message)
            
        case .typingStatusChanged(let message):
            handleTypingStatusChanged(message)
            
        case .errorOccurred(let error):
            handleError(error)
            
        case .connected:
            handleConnected()
            
        case .disconnected:
            handleDisconnected()
            
        default:
            break
        }
    }
    
    private func handleUserJoined(_ message: UserJoinedMessage) {
        let user = RemoteUser(
            id: message.userId,
            name: message.userName,
            avatarColor: message.avatarColor,
            status: .online,
            lastSeen: Date()
        )
        
        if !onlineUsers.contains(where: { $0.id == user.id }) {
            onlineUsers.append(user)
        }
        
        // Add system message
        let systemMessage = IncomingMessage(
            id: UUID().uuidString,
            timestamp: message.timestamp,
            content: .text("\(message.userName)が参加しました"),
            senderId: "system",
            senderName: "System",
            senderAvatarColor: "gray"
        )
        messages.append(systemMessage)
    }
    
    private func handleUserLeft(_ message: UserLeftMessage) {
        onlineUsers.removeAll { $0.id == message.userId }
        
        // Add system message
        let systemMessage = IncomingMessage(
            id: UUID().uuidString,
            timestamp: message.timestamp,
            content: .text("\(message.userName)が退出しました"),
            senderId: "system",
            senderName: "System",
            senderAvatarColor: "gray"
        )
        messages.append(systemMessage)
    }
    
    private func handleTypingStatusChanged(_ message: TypingStatusMessage) {
        if message.isTyping {
            typingUsers[message.userId] = message.userName
        } else {
            typingUsers.removeValue(forKey: message.userId)
        }
    }
    
    private func handleError(_ error: ErrorMessage) {
        print("WebSocket Error: \(error.errorDescription)")
        
        if error.retryable {
            // Attempt reconnection
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.connect()
            }
        }
    }
    
    private func handleConnected() {
        print("WebSocket Connected")
        flushMessageQueue()
    }
    
    private func handleDisconnected() {
        print("WebSocket Disconnected")
        typingUsers.removeAll()
    }
    
    private func flushMessageQueue() {
        Task {
            await flushMessageQueueAsync()
        }
    }
    
    private func flushMessageQueueAsync() async {
        let queue = messageQueue
        messageQueue.removeAll()
        
        for message in queue {
            await webSocketManager.sendMessage(message)
        }
    }
    
    private func updateTypingUsers(_ userIds: Set<String>) {
        // In real app, fetch user details from server
        // For now, use mock data
        var newTypingUsers: [String: String] = [:]
        for userId in userIds {
            newTypingUsers[userId] = "User \(userId.prefix(4))"
        }
        typingUsers = newTypingUsers
    }
    
    // MARK: - Mock Data Loading
    
    func loadMockRoom() {
        let mockUsers = User.sampleUsers.map { user in
            RemoteUser(
                id: UUID().uuidString,
                name: user.name,
                avatarColor: user.avatarColor.description,
                status: .online,
                lastSeen: Date()
            )
        }
        
        onlineUsers = mockUsers
        
        currentRoom = ChatRoom(
            id: UUID().uuidString,
            name: "オープンチャット",
            participants: mockUsers,
            createdAt: Date().addingTimeInterval(-86400),
            lastActivity: Date()
        )
    }
}