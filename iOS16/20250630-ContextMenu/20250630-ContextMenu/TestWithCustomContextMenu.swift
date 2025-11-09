import SwiftUI

// フレーム情報を取得するためのPreferenceKey
struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct TestWithCustomContextMenu: View {
    @State private var showingContextMenu = false
    @State private var menuPosition: CGPoint = .zero
    @State private var selectedBubbleFrame: CGRect = .zero
    @State private var selectedBubbleId: String? = nil
    @State private var bubbleFrames: [String: CGRect] = [:]
    @State private var isMenuAbove: Bool = false
    @State private var zstackCenter: CGPoint = .zero

    // メニューの表示位置を計算する関数（offset用に変更）
    private func calculateMenuOffset() -> CGSize {
        let menuHeight: CGFloat = 350
        let margin: CGFloat = 100
        let safeAreaTop: CGFloat = 50
        let safeAreaBottom: CGFloat = 50

        // ZStackのグローバル中心
        let centerX = zstackCenter.x
        let centerY = zstackCenter.y

        // バブルの中心X
        let bubbleCenterX = selectedBubbleFrame.midX
        // バブルの下端Y
        let bubbleBottomY = selectedBubbleFrame.maxY
        // バブルの上端Y
        let bubbleTopY = selectedBubbleFrame.minY

        // X座標（メニューの中央がバブルの中央に来るように）
        let menuX = bubbleCenterX
        let offsetX = menuX - centerX

        // Y座標
        var menuY: CGFloat
        // 下に表示できるか
        if bubbleBottomY + margin + menuHeight <= UIScreen.main.bounds.height - safeAreaBottom {
            // 下に表示（メニューの上端がバブルの下端＋marginに揃う）
            menuY = bubbleBottomY + margin
            isMenuAbove = false
        } else if bubbleTopY - margin - menuHeight >= safeAreaTop {
            // 上に表示（メニューの下端がバブルの上端−marginに揃う）
            menuY = bubbleTopY - margin
            isMenuAbove = true
        } else {
            // どちらも無理な場合は中央
            menuY = centerY
            isMenuAbove = false
        }
        let offsetY = menuY - centerY
        return CGSize(width: offsetX, height: offsetY)
    }
    
    // メニューが画面内に収まっているかチェックする関数
    private func isMenuInBounds(position: CGPoint) -> Bool {
        let screenBounds = UIScreen.main.bounds
        let menuHeight: CGFloat = 300
        let margin: CGFloat = 100

        let menuTop = position.y - menuHeight / 2
        let menuBottom = position.y + menuHeight / 2
        
        return menuTop >= margin &&
               menuBottom <= screenBounds.height - margin
    }

    var body: some View {
        GeometryReader { zstackGeo in
            ZStack(alignment: .center) {
                // メインコンテンツ（各バブルに個別にぼかし効果を適用）
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            MessageBubble(
                                id: "bubble1",
                                text: "こんにちは！今日はいい天気ですね☀️☀️こんにちは！今日はいい天気ですね☀️☀️こんにちは！今日はいい天気ですね☀️☀️",
                                showingContextMenu: $showingContextMenu,
                                menuPosition: $menuPosition,
                                selectedBubbleFrame: $selectedBubbleFrame,
                                selectedBubbleId: $selectedBubbleId,
                                bubbleFrames: $bubbleFrames
                            )

                            MessageBubble(
                                id: "bubble2",
                                text: "こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。こんにちは☺️そうですね！今日は本当にいい天気で、散歩日和ですね。公園に行ってみようかな？とても長いメッセージを書いてみました。これで複数行に表示されるはずです。",
                                showingContextMenu: $showingContextMenu,
                                menuPosition: $menuPosition,
                                selectedBubbleFrame: $selectedBubbleFrame,
                                selectedBubbleId: $selectedBubbleId,
                                bubbleFrames: $bubbleFrames
                            )
                            Spacer(minLength: 400) // スクロール可能にするためのスペーサー
                            MessageBubble(
                                id: "bubble3",
                                text: "こんにちは☺️そうですね！こんにちは！今日はいい天気ですね☀️☀️こんにちは！今日はいい天気ですね☀️☀️こんにちは！今日はいい天気ですね☀️☀️",
                                showingContextMenu: $showingContextMenu,
                                menuPosition: $menuPosition,
                                selectedBubbleFrame: $selectedBubbleFrame,
                                selectedBubbleId: $selectedBubbleId,
                                bubbleFrames: $bubbleFrames
                            )
                        }
                    }
                }

                // ContextMenuが表示されている時のオーバーレイ
                if showingContextMenu {

                    // カスタムメニューとオーバーレイコンテンツ
                    VStack(spacing: 20) {
                        if isMenuAbove {
                            // メニューが上に表示される場合は、アクション→リアクションの順
                            ActionMenu(
                                onReply: {
                                    showingContextMenu = false
                                    selectedBubbleId = nil
                                },
                                onReport: {
                                    showingContextMenu = false
                                    selectedBubbleId = nil
                                }
                            )
                            CustomOverlayContent()
                        } else {
                            // メニューが下に表示される場合は、リアクション→アクションの順
                            CustomOverlayContent()
                            ActionMenu(
                                onReply: {
                                    showingContextMenu = false
                                    selectedBubbleId = nil
                                },
                                onReport: {
                                    showingContextMenu = false
                                    selectedBubbleId = nil
                                }
                            )
                        }
                    }
                    .frame(maxWidth:  250, maxHeight: 300)
                    .offset(calculateMenuOffset())
                    .animation(.spring(response: 0.3), value: showingContextMenu)
                }
            }
            .onAppear {
                let frame = zstackGeo.frame(in: .global)
                zstackCenter = CGPoint(x: frame.midX, y: frame.midY)
            }
            .onChange(of: zstackGeo.frame(in: .global)) { newFrame in
                zstackCenter = CGPoint(x: newFrame.midX, y: newFrame.midY)
            }
        }
    }

    struct MessageBubble: View {
        let id: String
        let text: String
        @Binding var showingContextMenu: Bool
        @Binding var menuPosition: CGPoint
        @Binding var selectedBubbleFrame: CGRect
        @Binding var selectedBubbleId: String?
        @Binding var bubbleFrames: [String: CGRect]

        private var isSelected: Bool {
            selectedBubbleId == id
        }

        var body: some View {
            Text(text)
                .foregroundStyle(.white)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 2,
                        bottomLeadingRadius: 8,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 8
                    )
                    .fill(.blue)
                }
                .padding()
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
                    }
                )
                .onPreferenceChange(FramePreferenceKey.self) { frame in
                    bubbleFrames[id] = frame
                }
                .blur(radius: showingContextMenu && !isSelected ? 3 : 0)
                .animation(.easeInOut(duration: 0.2), value: showingContextMenu)
                .onLongPressGesture(minimumDuration: 0.2) {
                    // 長押し時にこのバブルのフレームを取得
                    if let frame = bubbleFrames[id] {
                        selectedBubbleFrame = frame
                        selectedBubbleId = id
                        showingContextMenu = true
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            menuPosition = value.location
                        }
                )
        }
    }

    struct Reaction: Identifiable {
        let id = UUID()
        let emoji: String
        let label: String
        let color: Color
    }

    let reactions: [Reaction] = [
        Reaction(emoji: "👍", label: "すごい", color: .yellow),
        Reaction(emoji: "❤️", label: "わかる", color: .pink),
        Reaction(emoji: "🎉", label: "応援", color: .orange),
        Reaction(emoji: "😭", label: "きになる", color: .cyan),
        Reaction(emoji: "👏", label: "おつかれさま", color: .pink)
    ]

    struct CustomOverlayContent: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("リアクション")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                HStack(spacing: 18) {
                    ReactionItem(emoji: "👍", label: "すごい", color: .yellow)
                    ReactionItem(emoji: "❤️", label: "わかる", color: .pink)
                    ReactionItem(emoji: "🎉", label: "応援", color: .orange)
                    ReactionItem(emoji: "😭", label: "きになる", color: .cyan)
                    ReactionItem(emoji: "👏", label: "おつかれさま", color: .pink)
                }
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
        }
    }

    struct ReactionItem: View {
        let emoji: String
        let label: String
        let color: Color
        var body: some View {
            VStack(spacing: 2) {
                Text(emoji)
                    .font(.system(size: 24))
                    .frame(width: 24, height: 24)
                Text(label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.2), radius: 1, x: 0, y: 1)
                    .frame(width: 24, height: 24)
                    .multilineTextAlignment(.center)
            }
        }
    }

    struct ActionMenu: View {
        let onReply: () -> Void
        let onReport: () -> Void
        var body: some View {
            VStack(spacing: 0) {
                Button(action: onReply) {
                    HStack {
                        Text("返信")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.system(size: 18))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                }
                Divider()
                Button(action: onReport) {
                    HStack {
                        Text("違反報告")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 18))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 2)
        }
    }

    struct MenuButton: View {
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    TestWithCustomContextMenu()
}
