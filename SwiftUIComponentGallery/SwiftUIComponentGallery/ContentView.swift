//
//  ContentView.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ChartList()
                } label: {
                    Text("チャート")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
