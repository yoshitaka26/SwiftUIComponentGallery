import Foundation

// MARK: - WebSocket Message Types

enum WebSocketMessageType: String, Codable {
    case message = "message"
    case userJoined = "user_joined"
    case userLeft = "user_left"
    case typing = "typing"
    case typingStop = "typing_stop"
    case messageRead = "message_read"
    case messageDeleted = "message_deleted"
    case error = "error"
    case ping = "ping"
    case pong = "pong"
}

// MARK: - Connection State

enum WebSocketConnectionState {
    case disconnected
    case connecting
    case connected
    case reconnecting
    case failed
}

// MARK: - Base Protocol

protocol WebSocketMessage: Codable {
    var type: WebSocketMessageType { get }
    var timestamp: Date { get }
}

// MARK: - Outgoing Messages

struct OutgoingTextMessage: WebSocketMessage {
    let type = WebSocketMessageType.message
    let timestamp: Date
    let text: String
    let senderId: String
    let senderName: String
    let messageId: String
    
    init(text: String, senderId: String, senderName: String) {
        self.text = text
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = Date()
        self.messageId = UUID().uuidString
    }
}

struct OutgoingImageMessage: WebSocketMessage {
    let type = WebSocketMessageType.message
    let timestamp: Date
    let imageData: Data
    let senderId: String
    let senderName: String
    let messageId: String
    
    init(imageData: Data, senderId: String, senderName: String) {
        self.imageData = imageData
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = Date()
        self.messageId = UUID().uuidString
    }
}

struct TypingIndicator: WebSocketMessage {
    let type: WebSocketMessageType
    let timestamp: Date
    let userId: String
    let userName: String
    
    init(userId: String, userName: String, isTyping: Bool) {
        self.type = isTyping ? .typing : .typingStop
        self.timestamp = Date()
        self.userId = userId
        self.userName = userName
    }
}

struct MessageReadReceipt: WebSocketMessage {
    let type = WebSocketMessageType.messageRead
    let timestamp: Date
    let messageId: String
    let userId: String
    
    init(messageId: String, userId: String) {
        self.messageId = messageId
        self.userId = userId
        self.timestamp = Date()
    }
}

// MARK: - Incoming Messages

struct IncomingMessage: WebSocketMessage, Identifiable {
    let id: String
    let type = WebSocketMessageType.message
    let timestamp: Date
    let content: MessageContent
    let senderId: String
    let senderName: String
    let senderAvatarColor: String?
    
    enum MessageContent: Codable {
        case text(String)
        case image(Data)
    }
}

struct UserJoinedMessage: WebSocketMessage {
    let type = WebSocketMessageType.userJoined
    let timestamp: Date
    let userId: String
    let userName: String
    let avatarColor: String
}

struct UserLeftMessage: WebSocketMessage {
    let type = WebSocketMessageType.userLeft
    let timestamp: Date
    let userId: String
    let userName: String
}

struct TypingStatusMessage: WebSocketMessage {
    let type: WebSocketMessageType
    let timestamp: Date
    let userId: String
    let userName: String
    let isTyping: Bool
}

struct ErrorMessage: WebSocketMessage {
    let type = WebSocketMessageType.error
    let timestamp: Date
    let errorCode: String
    let errorDescription: String
    let retryable: Bool
}

// MARK: - Room Management

struct ChatRoom: Codable {
    let id: String
    let name: String
    let participants: [RemoteUser]
    let createdAt: Date
    let lastActivity: Date
}

struct RemoteUser: Codable, Identifiable {
    let id: String
    let name: String
    let avatarColor: String
    let status: UserStatus
    let lastSeen: Date
    
    enum UserStatus: String, Codable {
        case online = "online"
        case offline = "offline"
        case away = "away"
        case typing = "typing"
    }
}

// MARK: - WebSocket Events

enum WebSocketEvent {
    case connected
    case disconnected(reason: String?)
    case messageReceived(IncomingMessage)
    case userJoined(UserJoinedMessage)
    case userLeft(UserLeftMessage)
    case typingStatusChanged(TypingStatusMessage)
    case errorOccurred(ErrorMessage)
    case connectionStateChanged(WebSocketConnectionState)
}

// MARK: - Error Types

enum WebSocketError: LocalizedError {
    case connectionFailed
    case authenticationFailed
    case invalidMessage
    case encodingFailed
    case decodingFailed
    case serverError(String)
    case networkUnavailable
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .connectionFailed:
            return "WebSocket接続に失敗しました"
        case .authenticationFailed:
            return "認証に失敗しました"
        case .invalidMessage:
            return "無効なメッセージです"
        case .encodingFailed:
            return "メッセージのエンコードに失敗しました"
        case .decodingFailed:
            return "メッセージのデコードに失敗しました"
        case .serverError(let message):
            return "サーバーエラー: \(message)"
        case .networkUnavailable:
            return "ネットワークが利用できません"
        case .timeout:
            return "接続がタイムアウトしました"
        }
    }
}

// MARK: - Configuration

struct WebSocketConfiguration {
    let url: URL
    let reconnectInterval: TimeInterval
    let maxReconnectAttempts: Int
    let heartbeatInterval: TimeInterval
    let messageTimeout: TimeInterval
    
    static let defaultConfiguration = WebSocketConfiguration(
        url: URL(string: "wss://example.com/chat")!,
        reconnectInterval: 3.0,
        maxReconnectAttempts: 5,
        heartbeatInterval: 30.0,
        messageTimeout: 10.0
    )
}
