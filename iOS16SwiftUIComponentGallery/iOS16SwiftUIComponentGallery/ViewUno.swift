
import SwiftUI

struct ViewUno: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.red
            VStack {
                Text("Uno")

                Button("push dos") {
                    router.push(.dos)
                }

                Button("present full screen dos") {
                    router.fullScreenCoverItemTrigger.send(.dos)
                }

                Button("present full screen with navigation dos") {
                    router.fullScreenWithNavigationCoverItemTrigger.send(.dos)
                }

                Button("push full screen with navigation dos") {
                    router.pushFullScreenWithNavigationPath(.dos)
                }

                Button("dismiss") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    ViewUno()
}
