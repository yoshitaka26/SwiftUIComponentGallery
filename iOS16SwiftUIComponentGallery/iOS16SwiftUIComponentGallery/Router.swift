
import SwiftUI
import Combine

class Router: ObservableObject {
    @Published var selection: Tab = .first
    @Published var fullScreenWithNavigationPath: NavigationPath = .init()
    @Published var tabFirstPath: NavigationPath = .init()
    @Published var tabSecondPath: NavigationPath = .init()
    @Published var tabThirdPath: NavigationPath = .init()

    @Published var fullScreenModal: Screen?

    func present(_ screen: Screen) {
        fullScreenModal = screen
    }

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
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            fullScreenWithNavigationPath.append(screen)
        }
    }

    func popFullScreenWithNavigationPath() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            fullScreenWithNavigationPath.removeLast()
        }
    }

    let fullScreenCoverItemTrigger = PassthroughSubject<Screen, Never>()

    let fullScreenWithNavigationCoverItemTrigger = PassthroughSubject<Screen, Never>()
}
