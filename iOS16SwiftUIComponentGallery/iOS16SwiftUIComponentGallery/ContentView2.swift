//
//  ContentView2.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/12/16.
//

import SwiftUI

struct ContentView2: View {
    @StateObject var router = Router()

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
        .environmentObject(router)
    }
}

#Preview {
    ContentView2()
}
