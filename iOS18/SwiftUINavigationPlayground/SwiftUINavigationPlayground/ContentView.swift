import SwiftUI

// デフォルト（フルスクリーンに対してのPushの正常挙動を確認）
struct ContentView: View {
    @StateObject var router = Router(testType: .normal)

    var body: some View {
        TabView(selection: $router.selection) {
            NavigationStack(path: $router.tabFirstPath) {
                Screen.uno.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.first)
            .tabItem {
                Label("First", systemImage: "1.circle")
            }

            NavigationStack(path: $router.tabSecondPath) {
                Screen.dos.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.second)
            .tabItem {
                Label("Second", systemImage: "2.circle")
            }

            NavigationStack(path: $router.tabThirdPath) {
                Screen.tres.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.third)
            .tabItem {
                Label("Third", systemImage: "3.circle")
            }
        }
        .fullScreenCover(item: $router.fullScreenModal) { screen in
            NavigationStack {
                NavigationLink {
                    Sample2View()
                } label: {
                    Sample1View()
                }
            }
        }
        .environmentObject(router)
    }

    private struct Sample1View: View {
        var body: some View {
            Text("Sample")
        }
    }

    private struct Sample2View: View {
        var body: some View {
            NavigationLink {
                Sample1View()
            } label: {
                Text("Sample")
            }
        }
    }
}

// フルスクリーンモーダルの画面遷移をRouterで制御する場合
// フルスクリーンに対してPushした場合の遷移アニメーションが変だが、これだけなら解消方法はありそう
struct ContentView1: View {
    @StateObject var router = Router(testType: .normal)

    var body: some View {
        TabView(selection: $router.selection) {
            NavigationStack(path: $router.tabFirstPath) {
                Screen.uno.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.first)
            .tabItem {
                Label("First", systemImage: "1.circle")
            }

            NavigationStack(path: $router.tabSecondPath) {
                Screen.dos.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.second)
            .tabItem {
                Label("Second", systemImage: "2.circle")
            }

            NavigationStack(path: $router.tabThirdPath) {
                Screen.tres.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
            .tag(Tab.third)
            .tabItem {
                Label("Third", systemImage: "3.circle")
            }
        }
        .fullScreenCover(item: $router.fullScreenModal) { screen in
            NavigationStack(path: $router.fullScreenWithNavigationPath) {
                screen.view()
                    .navigationDestination(for: Screen.self) { screen in
                        screen.view()
                    }
            }
        }
        .task {
            // Deeplinkの挙動を再現
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                NotificationCenter.default.post(
                    name: AppDelegate.deepLinkNotification,
                    object: nil,
                    userInfo: ["screen": Screen.tres]
                )
            } catch {
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: AppDelegate.deepLinkNotification)) { notification in
            if let screen = notification.userInfo?["screen"] as? Screen {
                router.fullScreenCoverItemTrigger.send(screen)
            }
        }
        .environmentObject(router)
    }
}

// 無限フルスクリーンモーダル表示
struct ContentView2: View {
    @StateObject var router = Router(testType: .infiniteFullScreen)

    var body: some View {
        FullScreenCoverView(currentScreen: .constant(nil)) {
            TabView(selection: $router.selection) {
                NavigationStack(path: $router.tabFirstPath) {
                    Screen.uno.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.first)
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }

                NavigationStack(path: $router.tabSecondPath) {
                    Screen.dos.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.second)
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }

                NavigationStack(path: $router.tabThirdPath) {
                    Screen.tres.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.third)
                .tabItem {
                    Label("Third", systemImage: "3.circle")
                }
            }
            .fullScreenCover(item: $router.fullScreenModal) { screen in
                NavigationStack(path: $router.fullScreenWithNavigationPath) {
                    screen.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
            }
        }
        .task {
            // Deeplinkの挙動を再現
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                NotificationCenter.default.post(
                    name: AppDelegate.deepLinkNotification,
                    object: nil,
                    userInfo: ["screen": Screen.tres]
                )
            } catch {
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: AppDelegate.deepLinkNotification)) { notification in
            if let screen = notification.userInfo?["screen"] as? Screen {
                router.fullScreenCoverItemTrigger.send(screen)
            }
        }
        .environmentObject(router)
    }
}

// ナビゲーションバー付きの無限フルスクリーンモーダル表示
// この実装は厳しい。フルモーダルが無限に表示できるかつかくモーダルに対してPushもできる状態にはできなそう
struct ContentView3: View {
    @StateObject var router = Router(testType: .infiniteFullScreenWithNavigation)

    var body: some View {
        FullScreenCoverWithNavigationView(currentScreen: .constant(nil)) {
            TabView(selection: $router.selection) {
                NavigationStack(path: $router.tabFirstPath) {
                    Screen.uno.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.first)
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }

                NavigationStack(path: $router.tabSecondPath) {
                    Screen.dos.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.second)
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }

                NavigationStack(path: $router.tabThirdPath) {
                    Screen.tres.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
                .tag(Tab.third)
                .tabItem {
                    Label("Third", systemImage: "3.circle")
                }
            }
            .fullScreenCover(item: $router.fullScreenModal) { screen in
                NavigationStack(path: $router.fullScreenWithNavigationPath) {
                    screen.view()
                        .navigationDestination(for: Screen.self) { screen in
                            screen.view()
                        }
                }
            }
        }
        .task {
            // Deeplinkの挙動を再現
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                NotificationCenter.default.post(
                    name: AppDelegate.deepLinkNotification,
                    object: nil,
                    userInfo: ["screen": Screen.tres]
                )
            } catch {
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: AppDelegate.deepLinkNotification)) { notification in
            if let screen = notification.userInfo?["screen"] as? Screen {
                router.fullScreenCoverItemTrigger.send(screen)
            }
        }
        .environmentObject(router)
    }
}

#Preview {
    ContentView1()
}

