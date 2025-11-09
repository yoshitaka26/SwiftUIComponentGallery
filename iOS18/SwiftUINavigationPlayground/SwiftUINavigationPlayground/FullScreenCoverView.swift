import SwiftUI

// https://blog.studysapuri.jp/entry/2021/09/18/iosdc-swiftui-infinite-fullscreen-cover-modal

// 無限フルスクリーンモーダ表示用
struct FullScreenCoverView<Content: View>: View {
    @EnvironmentObject private var router: Router

    @Binding var currentScreen: Screen?
    @State var nextScreen: Screen?

    let content: () -> Content

    var body: some View {
        let _ = Self._printChanges()
        content()
            .onReceive(router.fullScreenCoverItemTrigger) { screen in
                if nextScreen == nil {
                    nextScreen = screen
                }
            }
            .fullScreenCover(item: $nextScreen) { screen in
                screen.viewFillScreen(with: $nextScreen)
            }
    }
}

// 無限フルスクリーンモーダ表示用（ナビゲーション付き）
struct FullScreenCoverWithNavigationView<Content: View>: View {

    @EnvironmentObject private var router: Router

    @Binding var currentScreen: Screen?
    @State var nextScreen: Screen?

    let content: () -> Content

    var body: some View {
        let _ = Self._printChanges()
        content()
            .onReceive(router.fullScreenWithNavigationCoverItemTrigger) { screen in
                if nextScreen == nil {
                    nextScreen = screen
                }
            }
            .fullScreenCover(item: $nextScreen) { screen in
                screen.viewFillScreenWithNavigation(path: $router.fullScreenWithNavigationPath, with: $nextScreen)
            }
    }
}
