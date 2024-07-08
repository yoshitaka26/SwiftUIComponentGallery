//
//  ContentView.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
//        .fullScreenCover(isPresented: .constant(true), content: {
//            StickyHeaderTabView()
//        })
    }
}

#Preview {
    ContentView()
}
