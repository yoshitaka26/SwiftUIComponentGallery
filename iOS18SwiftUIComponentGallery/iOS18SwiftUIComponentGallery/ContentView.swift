import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink {
                    MapView()
                } label: {
                    Text("地図")
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
}
