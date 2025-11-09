import SwiftUI

struct TestWithZStack: View {
    @State private var isContextMenuVisible = false
    @State private var overlayContent = "デフォルト"

    var body: some View {
        ZStack {
            // メインコンテンツ
            Text("長押ししてください")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .contextMenu {
                    Button("アクション1") {
                        isContextMenuVisible = false
                    }
                    Button("アクション2") {
                        isContextMenuVisible = false
                    }
                }
                .onLongPressGesture(minimumDuration: 0.3) {
                    isContextMenuVisible = true
                    overlayContent = "ContextMenuが表示中"
                }

            // オーバーレイコンテンツ
            if isContextMenuVisible {
                VStack {
                    Text(overlayContent)
                        .font(.headline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                        .shadow(radius: 5)

                    Spacer()
                }
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    TestWithZStack()
}
