
import SwiftUI

struct ContentView: View {
    @StateObject var router = Router()

    var body: some View {
        FullScreenCoverWithNavigationView(currentScreen: .constant(nil)) {
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
    ContentView()
}
