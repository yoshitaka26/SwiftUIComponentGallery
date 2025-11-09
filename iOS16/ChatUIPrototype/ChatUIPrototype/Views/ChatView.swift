import SwiftUI

enum ContentAmount: String, CaseIterable {
    case all = "全量"
    case half = "半分"
    case three = "最新3件"

    var displayName: String {
        return self.rawValue
    }
}

struct ChatView: View {
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
                    LazyVStack(alignment: .leading, spacing: 4) {
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
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        scrollProxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
                .onChange(of: contentAmount) { _ in
                    // Scroll to bottom when content amount changes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            scrollProxy.scrollTo(bottomID, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.shouldScrollToBottom) { shouldScroll in
                    if shouldScroll {
                        withAnimation(.easeOut(duration: 0.3)) {
                            scrollProxy.scrollTo(bottomID, anchor: .bottom)
                        }
                        viewModel.shouldScrollToBottom = false
                    }
                }
                .onAppear {
                    // 初期表示時に最下部にスクロール
                    scrollProxy.scrollTo(bottomID, anchor: .bottom)
                }
            }

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

struct MessageInputView: View {
    @ObservedObject var viewModel: ChatViewModel
    @Binding var showImagePicker: Bool
    @Binding var replyToMessage: ChatMessage?
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // 返信表示
            if let replyTo = replyToMessage {
                HStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("返信: \(replyTo.sender.name)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)

                        Text(replyTo.displayText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }

                    Spacer()

                    Button(action: {
                        replyToMessage = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))

                Divider()
            }

            HStack(spacing: 12) {
                // 画像選択ボタン
                Button(action: {
                    viewModel.sendImage(replyToId: replyToMessage?.id)
                    replyToMessage = nil
                }) {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                // テキスト入力フィールド
                HStack {
                    TextField("メッセージを入力...", text: $viewModel.inputText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            if !viewModel.inputText.isEmpty {
                                viewModel.sendMessage(text: viewModel.inputText, replyToId: replyToMessage?.id)
                                replyToMessage = nil
                            }
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)

                // 送信ボタン
                Button(action: {
                    if !viewModel.inputText.isEmpty {
                        viewModel.sendMessage(text: viewModel.inputText, replyToId: replyToMessage?.id)
                        replyToMessage = nil
                        isTextFieldFocused = false
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(viewModel.inputText.isEmpty ? .gray : .blue)
                }
                .disabled(viewModel.inputText.isEmpty)
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
    }
}

extension View {
    @ViewBuilder
    func scrollAnchor() -> some View {
        if #available(iOS 18.0, *) {
            self
                .defaultScrollAnchor(.bottom, for: .initialOffset)
                .defaultScrollAnchor(.top, for: .alignment)
                .defaultScrollAnchor(.bottom, for: .sizeChanges)
        } else if #available(iOS 17.0, *) {
            self.defaultScrollAnchor(.bottom)
        } else {
            self
        }
    }
}
