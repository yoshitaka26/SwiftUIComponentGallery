import SwiftUI

struct ViewUno: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.red
            VStack {
                Text("Uno画面")
                    .font(.title)

                Button("Dos画面をpush表示") {
                    router.push(.dos)
                }

                Button("Dos画面をpresent表示") {
                    router.present(.dos)
                }

                if router.testType == .infiniteFullScreen {
                    Button("Dos画面を無限モーダル対応でpresent表示") {
                        router.fullScreenCoverItemTrigger.send(.dos)
                    }
                }

                if router.testType == .infiniteFullScreenWithNavigation {
                    Button("Dos画面を無限モーダル対応(ナビゲーション付き)でpresent表示") {
                        router.fullScreenWithNavigationCoverItemTrigger.send(.dos)
                    }
                }

                Divider()

                Button("Dos画面をモーダル画面にPush表示") {
                    router.pushFullScreenWithNavigationPath(.dos)
                }

                Divider()

                Button("閉じる") {
                    dismiss()
                }
            }
        }
    }
}

struct ViewDos: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.yellow
            VStack {
                Text("Dos画面")
                    .font(.title)

                Button("Tres画面をpush表示") {
                    router.push(.tres)
                }

                Button("Tres画面をpresent表示") {
                    router.present(.tres)
                }

                if router.testType == .infiniteFullScreen {
                    Button("Tres画面を無限モーダル対応でpresent表示") {
                        router.fullScreenCoverItemTrigger.send(.tres)
                    }
                }

                if router.testType == .infiniteFullScreenWithNavigation {
                    Button("Tres画面を無限モーダル対応(ナビゲーション付き)でpresent表示") {
                        router.fullScreenWithNavigationCoverItemTrigger.send(.tres)
                    }
                }

                Divider()

                Button("Tres画面をモーダル画面にPush表示") {
                    router.pushFullScreenWithNavigationPath(.tres)
                }

                Divider()

                Button("閉じる") {
                    dismiss()
                }
            }
        }
    }
}

struct ViewTres: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.green
            VStack {
                Text("Tres画面")
                    .font(.title)

                Button("Uno画面をpush表示") {
                    router.push(.uno)
                }

                Button("Uno画面をpresent表示") {
                    router.present(.uno)
                }

                if router.testType == .infiniteFullScreen {
                    Button("Uno画面を無限モーダル対応でpresent表示") {
                        router.fullScreenCoverItemTrigger.send(.uno)
                    }
                }

                if router.testType == .infiniteFullScreenWithNavigation {
                    Button("Uno画面を無限モーダル対応(ナビゲーション付き)でpresent表示") {
                        router.fullScreenWithNavigationCoverItemTrigger.send(.uno)
                    }
                }

                Divider()

                Button("Uno画面をモーダル画面にPush表示") {
                    router.pushFullScreenWithNavigationPath(.uno)
                }

                Divider()

                Button("閉じる") {
                    dismiss()
                }
            }
        }
    }
}
