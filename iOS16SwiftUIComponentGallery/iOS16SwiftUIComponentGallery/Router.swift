
import SwiftUI
import Combine

class Router: ObservableObject {
    @Published var selection: Tab = .first
    @Published var fullScreenWithNavigationPath: NavigationPath = .init()
    @Published var tabFirstPath: NavigationPath = .init()
    @Published var tabSecondPath: NavigationPath = .init()
    @Published var tabThirdPath: NavigationPath = .init()

    func push(_ screen: Screen) {
        switch selection {
        case .first:
            tabFirstPath.append(screen)
        case .second:
            tabSecondPath.append(screen)
        case .third:
            tabThirdPath.append(screen)
        }
    }

    func pushFullScreenWithNavigationPath(_ screen: Screen) {
        fullScreenWithNavigationPath.append(screen)
    }

    let fullScreenCoverItemTrigger = PassthroughSubject<Screen, Never>()

    let fullScreenWithNavigationCoverItemTrigger = PassthroughSubject<Screen, Never>()
}
