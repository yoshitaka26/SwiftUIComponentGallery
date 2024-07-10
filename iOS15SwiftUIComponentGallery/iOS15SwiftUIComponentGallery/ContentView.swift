//
//  ContentView.swift
//  iOS15SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/07/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ListView()
                } label: {
                    Text("リスト(List)")
                }
                NavigationLink {
                    ListWithScrollView()
                } label: {
                    Text("リスト(ScrollView)")
                }
                NavigationLink {
                    ListWithLazyVStack()
                } label: {
                    Text("リスト(LazyVStack)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
