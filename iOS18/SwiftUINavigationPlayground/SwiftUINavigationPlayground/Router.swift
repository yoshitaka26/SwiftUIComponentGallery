import SwiftUI
import Combine

enum Tab {
    case first
    case second
    case third
}

enum TestType {
    case normal
    case infiniteFullScreen
    case infiniteFullScreenWithNavigation
}

class Router: ObservableObject {
    @Published var testType: TestType = .normal

    @Published var selection: Tab = .first
    @Published var tabFirstPath: NavigationPath = .init()
    @Published var tabSecondPath: NavigationPath = .init()
    @Published var tabThirdPath: NavigationPath = .init()

    @Published var fullScreenModal: Screen?
    @Published var fullScreenWithNavigationPath: NavigationPath = .init()

    init(testType: TestType) {
        self.testType = testType
    }

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

        fullScreenWithNavigationPath.append(screen)

//        var transaction = Transaction()
//        transaction.disablesAnimations = true
//        withTransaction(transaction) {}
    }

    let fullScreenCoverItemTrigger = PassthroughSubject<Screen, Never>()

    let fullScreenWithNavigationCoverItemTrigger = PassthroughSubject<Screen, Never>()
}
