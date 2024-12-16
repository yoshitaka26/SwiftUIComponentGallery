
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

                Button("present single full screen with navigation dos") {
                    router.present(.dos)
                }

                Divider()

                Button("present full screen dos") {
                    router.fullScreenCoverItemTrigger.send(.dos)
                }

                Button("present full screen with navigation dos") {
                    router.fullScreenWithNavigationCoverItemTrigger.send(.dos)
                }

                Divider()

                Button("push full screen with navigation dos") {
                    router.pushFullScreenWithNavigationPath(.dos)
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
    ViewUno()
}
