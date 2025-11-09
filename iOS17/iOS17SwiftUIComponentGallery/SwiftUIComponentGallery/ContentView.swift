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
                    ChatListView()
                } label: {
                    Text("チャット画面")
                }
                NavigationLink {
                    DragAndDropView()
                } label: {
                    Text("ドラッグアンドドロップ")
                }
                NavigationLink {
                    LegacyPhotoPickerView()
                } label: {
                    Text("カメラと写真")
                }
                NavigationLink {
                    ProfilePhotoPickerView()
                } label: {
                    Text("プロフィール写真")
                }
                NavigationLink {
                    InlinePhotosPickerView()
                } label: {
                    Text("インライン写真")
                }
                NavigationLink {
                    InlineMultiPhotosPickerView()
                } label: {
                    Text("インライン複数写真")
                }
                NavigationLink {
                    ChartList()
                } label: {
                    Text("チャート")
                }
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
//        .fullScreenCover(isPresented: .constant(true), content: {
//            StickyHeaderTabView()
//        })
    }
}

#Preview {
    ContentView()
}
