import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    let replyToMessage: ChatMessage?
    var isHighlighted: Bool = false
    var onReplyTap: ((UUID) -> Void)? = nil
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.sender.isCurrentUser {
                Spacer(minLength: 50)
            } else {
                // アバター
                Circle()
                    .fill(message.sender.avatarColor)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(String(message.sender.name.prefix(1)))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: message.sender.isCurrentUser ? .trailing : .leading, spacing: 4) {
                // 返信表示
                if let replyTo = replyToMessage {
                    Button(action: {
                        onReplyTap?(replyTo.id)
                    }) {
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.5))
                                .frame(width: 3)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(replyTo.sender.name)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                
                                Text(replyTo.displayText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // ユーザー名と時刻
                HStack(spacing: 8) {
                    if !message.sender.isCurrentUser {
                        Text(message.sender.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary.opacity(0.8))
                    }
                    
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // メッセージバブル
                Group {
                    switch message.content {
                    case .text(let text):
                        Text(text)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(message.sender.isCurrentUser ? 
                                          Color.blue : 
                                          Color(UIColor.systemGray6))
                            )
                            .foregroundColor(message.sender.isCurrentUser ? .white : .primary)
                    
                    case .image(let imageName):
                        AsyncImage(url: URL(string: "https://picsum.photos/seed/\(imageName)/200/300")) { phase in
                            switch phase {
                            case .empty:
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 300)
                                    .overlay(
                                        ProgressView()
                                            .scaleEffect(1.5)
                                    )
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 300)
                                    .clipped()
                                    .cornerRadius(12)
                            case .failure:
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 300)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "photo")
                                                .font(.largeTitle)
                                                .foregroundColor(.gray)
                                            Text("画像を読み込めませんでした")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(message.sender.isCurrentUser ? 
                                      Color.blue.opacity(0.1) : 
                                      Color(UIColor.systemGray6))
                        )
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.65, 
                   alignment: message.sender.isCurrentUser ? .trailing : .leading)
            
            if !message.sender.isCurrentUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
        .offset(x: shakeOffset)
        .onChange(of: isHighlighted) { highlighted in
            if highlighted {
                // シェイクアニメーションを開始
                withAnimation(
                    Animation.easeInOut(duration: 0.1)
                        .repeatCount(6, autoreverses: true)
                ) {
                    shakeOffset = 8
                }
                
                // アニメーション終了後にリセット
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    shakeOffset = 0
                }
            }
        }
        .background(
            // ハイライト背景
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.yellow.opacity(isHighlighted ? 0.3 : 0))
                .animation(.easeInOut(duration: 0.3), value: isHighlighted)
        )
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
