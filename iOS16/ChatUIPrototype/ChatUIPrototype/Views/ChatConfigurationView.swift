import SwiftUI

enum ChatViewType {
    case normal
    case withDefaultScrollAnchor

    var displayName: String {
        switch self {
        case .normal:
            return "通常スクロール"
        case .withDefaultScrollAnchor:
            return "DefaultScrollAnchor"
        }
    }
}

struct ChatConfiguration: Identifiable {
    let id = UUID()
    let title: String
    let contentAmount: ContentAmount
    let showImages: Bool
    let description: String
    let viewType: ChatViewType

    var icon: String {
        switch contentAmount {
        case .all:
            return "square.stack.3d.up.fill"
        case .half:
            return "square.stack.3d.up.slash"
        case .three:
            return "text.alignleft"
        }
    }

    var iconColor: Color {
        switch contentAmount {
        case .all:
            return .blue
        case .half:
            return .orange
        case .three:
            return .green
        }
    }
}

struct ChatConfigurationView: View {
    @State private var navigateToChat = false
    @State private var selectedConfiguration: ChatConfiguration?

    let normalScrollConfigurations = [
        // 通常スクロール版 - 全量
        ChatConfiguration(
            title: "全量表示（画像あり） - 通常",
            contentAmount: .all,
            showImages: true,
            description: "すべてのメッセージと画像を表示",
            viewType: .normal
        ),
        ChatConfiguration(
            title: "全量表示（テキストのみ） - 通常",
            contentAmount: .all,
            showImages: false,
            description: "すべてのテキストメッセージのみ表示",
            viewType: .normal
        ),

        // 通常スクロール版 - 半分
        ChatConfiguration(
            title: "半分表示（画像あり） - 通常",
            contentAmount: .half,
            showImages: true,
            description: "最新の半分のメッセージと画像を表示",
            viewType: .normal
        ),
        ChatConfiguration(
            title: "半分表示（テキストのみ） - 通常",
            contentAmount: .half,
            showImages: false,
            description: "最新の半分のテキストメッセージのみ表示",
            viewType: .normal
        ),

        // 通常スクロール版 - 最新3件
        ChatConfiguration(
            title: "最新3件（テキストのみ） - 通常",
            contentAmount: .three,
            showImages: false,
            description: "最新のテキストメッセージ3件を表示",
            viewType: .normal
        ),

    ]

    let scrollAnchorConfigurations = [
        // DefaultScrollAnchor版 - 全量
        ChatConfiguration(
            title: "全量表示（画像あり） - ScrollAnchor",
            contentAmount: .all,
            showImages: true,
            description: "DefaultScrollAnchorを使用",
            viewType: .withDefaultScrollAnchor
        ),
        ChatConfiguration(
            title: "全量表示（テキストのみ） - ScrollAnchor",
            contentAmount: .all,
            showImages: false,
            description: "DefaultScrollAnchorを使用",
            viewType: .withDefaultScrollAnchor
        ),

        // DefaultScrollAnchor版 - 半分
        ChatConfiguration(
            title: "半分表示（画像あり） - ScrollAnchor",
            contentAmount: .half,
            showImages: true,
            description: "DefaultScrollAnchorを使用",
            viewType: .withDefaultScrollAnchor
        ),
        ChatConfiguration(
            title: "半分表示（テキストのみ） - ScrollAnchor",
            contentAmount: .half,
            showImages: false,
            description: "DefaultScrollAnchorを使用",
            viewType: .withDefaultScrollAnchor
        ),

        // DefaultScrollAnchor版 - 最新3件
        ChatConfiguration(
            title: "最新3件（テキストのみ） - ScrollAnchor",
            contentAmount: .three,
            showImages: false,
            description: "DefaultScrollAnchorを使用",
            viewType: .withDefaultScrollAnchor
        )
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("通常スクロール")) {
                    ForEach(normalScrollConfigurations) { config in
                        ConfigurationRow(config: config)
                    }
                }

                Section(header: Text("DefaultScrollAnchor")) {
                    ForEach(scrollAnchorConfigurations) { config in
                        ConfigurationRow(config: config)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("チャット設定")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            print("About tapped")
                        }) {
                            Label("このアプリについて", systemImage: "info.circle")
                        }

                        Button(action: {
                            print("Settings tapped")
                        }) {
                            Label("設定", systemImage: "gear")
                        }

                        Divider()

                        Button(action: {
                            print("Help tapped")
                        }) {
                            Label("ヘルプ", systemImage: "questionmark.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConfigurationRow: View {
    let config: ChatConfiguration

    var body: some View {
        NavigationLink(
            destination: Group {
                if config.viewType == .normal {
                    ChatView(
                        contentAmount: config.contentAmount,
                        showImages: config.showImages
                    )
                } else {
                    ChatWithDefaultScrollAnchorView(
                        contentAmount: config.contentAmount,
                        showImages: config.showImages
                    )
                }
            }
        ) {
            VStack(alignment: .leading, spacing: 4) {
                Text(config.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(config.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
}


struct ChatConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ChatConfigurationView()
    }
}
