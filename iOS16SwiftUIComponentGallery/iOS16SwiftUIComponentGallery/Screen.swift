
import SwiftUI

enum Screen: Identifiable {
    var id: String { UUID().uuidString }

    case uno
    case dos
    case tres

    @ViewBuilder
    func view() -> some View{
        switch self {
        case .uno: ViewUno()
        case .dos: ViewDos()
        case .tres: ViewTres()
        }
    }

    @ViewBuilder
    func viewFillScreen(with item: Binding<Screen?>) -> some View{
        FullScreenCoverView(currentScreen: item) {
            view()
        }
    }

    @ViewBuilder
    func viewFillScreenWithNavigation(path: Binding<NavigationPath>, with item: Binding<Screen?>) -> some View{
        NavigationStack(path: path) {
            view()
                .navigationDestination(for: Screen.self) { screen in
                    screen.view()
                }
        }
    }
}
