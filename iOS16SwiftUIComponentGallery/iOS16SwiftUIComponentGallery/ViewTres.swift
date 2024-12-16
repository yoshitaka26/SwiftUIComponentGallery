
import SwiftUI

struct ViewTres: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.green
            VStack {
                Text("Tres")

                Button("push Uno") {
                    router.push(.uno)
                }

                Button("present single full screen with navigation uno") {
                    router.present(.uno)
                }

                Divider()

                Button("present full screen Uno") {
                    router.fullScreenCoverItemTrigger.send(.uno)
                }

                Button("present full screen with navigation uno") {
                    router.fullScreenWithNavigationCoverItemTrigger.send(.uno)
                }

                Divider()

                Button("push full screen with navigation uno") {
                    router.pushFullScreenWithNavigationPath(.uno)
                }

                Button("pop full screen with navigation") {
                    router.popFullScreenWithNavigationPath()
                }

                Divider()

                Button("dismiss") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ViewTres()
}
