import SwiftUI

struct TestWithDefaultComponent: View {
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 15) {
                    MessageBubble(text: "こんにちは！今日はいい天気ですね☀️")

                    MessageBubble(text: "こんにちは☺️そうですね！")
                }
            }
        }
    }

    private struct MessageBubble: View {
        let text: String

        var body: some View {
            Text(text)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
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
                .contextMenu {
                    Button("コピー") { }
                    Button("共有") { }
                } preview: {
                    Button("追加のボタン") {}
                }
        }
    }
}

#Preview {
    TestWithDefaultComponent()
}
