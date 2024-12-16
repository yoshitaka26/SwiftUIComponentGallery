
import SwiftUI

struct ViewDos: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router

    var body: some View {
        ZStack {
            Color.yellow
            VStack {
                Text("Dos")

                Button("push tres") {
                    router.push(.tres)
                }

                Button("present full screen tres") {
                    router.fullScreenCoverItemTrigger.send(.tres)
                }

                Button("present full screen with navigation tres") {
                    router.fullScreenWithNavigationCoverItemTrigger.send(.tres)
                }

                Button("push full screen with navigation tres") {
                    router.pushFullScreenWithNavigationPath(.tres)
                }


                Button("dismiss") {
                    dismiss()
                }
            }
        }
    }
}

class ViewDosModel: ObservableObject {
}

#Preview {
    ViewDos()
}
