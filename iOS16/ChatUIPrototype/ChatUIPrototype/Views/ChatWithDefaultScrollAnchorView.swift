import SwiftUI

struct ChatWithDefaultScrollAnchorView: View {
    @StateObject private var viewModel = ChatViewModel()
    @Namespace private var bottomID
    @State private var showImagePicker = false
    @State private var replyToMessage: ChatMessage? = nil
    @State private var highlightedMessageId: UUID? = nil
    @Environment(\.dismiss) private var dismiss

    let contentAmount: ContentAmount
    let showImages: Bool

    init(contentAmount: ContentAmount = .all, showImages: Bool = true) {
        self.contentAmount = contentAmount
        self.showImages = showImages
    }

    private var displayedMessages: [ChatMessage] {
        var messages: [ChatMessage]

        // First filter by content amount
        switch contentAmount {
        case .all:
            messages = viewModel.messages
        case .half:
            let halfCount = viewModel.messages.count / 2
            messages = Array(viewModel.messages.suffix(halfCount))
        case .three:
            // For latest 3, only show text messages
            let textOnlyMessages = viewModel.messages.filter { message in
                switch message.content {
                case .text:
                    return true
                case .image:
                    return false
                }
            }
            messages = Array(textOnlyMessages.suffix(3))
        }

        // Then filter out images if needed (not for .three since it's already text-only)
        if !showImages && contentAmount != .three {
            messages = messages.filter { message in
                switch message.content {
                case .text:
                    return true
                case .image:
                    return false
                }
            }
        }

        return messages
    }

    var body: some View {
        VStack(spacing: 0) {
            // メッセージリスト
            ScrollViewReader { scrollProxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(displayedMessages) { message in
                            MessageBubbleView(
                                message: message,
                                replyToMessage: viewModel.getMessageById(message.replyToId),
                                isHighlighted: highlightedMessageId == message.id,
                                onReplyTap: { replyId in
                                    // Check if the message is in the current displayed messages
                                    if displayedMessages.contains(where: { $0.id == replyId }) {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            scrollProxy.scrollTo(replyId, anchor: .center)
                                        }

                                        // ハイライトとシェイクアニメーション
                                        highlightedMessageId = replyId

                                        // 2秒後にハイライトを解除
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                highlightedMessageId = nil
                                            }
                                        }
                                    }
                                }
                            )
                            .id(message.id)
                            .contextMenu {
                                Button(action: {
                                    replyToMessage = message
                                }) {
                                    Label("返信", systemImage: "arrowshape.turn.up.left")
                                }
                            }
                        }

                        // 自動スクロール用の見えないビュー
                        Color.clear
                            .frame(height: 1)
                            .id(bottomID)
                    }
                    .padding(.vertical)
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            .scrollAnchor()

            Divider()

            // 入力エリア
            MessageInputView(
                viewModel: viewModel,
                showImagePicker: $showImagePicker,
                replyToMessage: $replyToMessage
            )
        }
        .navigationTitle("チャット")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("画面を閉じる", systemImage: "xmark.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
