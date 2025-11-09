import SwiftUI
import ExyteChat

struct ChatListView: View {
    @State var messages: [Message] = [
        Message(id: "1", user: User(id: "1", name: "テスト", avatarURL: nil, type: .current), status: nil, createdAt: Date(), text: "テスト投稿", attachments: [], giphyMediaId: nil, reactions: [], recording: nil, replyMessage: nil),
        Message(id: "2", user: User(id: "2", name: "テスト", avatarURL: nil, type: .current), status: nil, createdAt: Date(), text: "テスト投稿", attachments: [], giphyMediaId: nil, reactions: [], recording: nil, replyMessage: nil),
        Message(id: "3", user: User(id: "3", name: "テスト", avatarURL: nil, type: .current), status: nil, createdAt: Date(), text: "テスト投稿", attachments: [], giphyMediaId: nil, reactions: [], recording: nil, replyMessage: nil)
    ]

    var body: some View {
        ChatView(messages: messages) { message in
            print(message.text)
        }
    }
}

#Preview {
    ChatListView()
}
