
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

                Button("present full screen Uno") {
                    router.fullScreenCoverItemTrigger.send(.uno)
                }

                Button("present full screen with navigation uno") {
                    router.fullScreenWithNavigationCoverItemTrigger.send(.uno)
                }

                Button("push full screen with navigation uno") {
                    router.pushFullScreenWithNavigationPath(.uno)
                }

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
