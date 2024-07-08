//
//  PagerTabStripSampleView.swift
//  SwiftUIComponentGallery
//
//  Created by yoshitaka on 2024/07/03.
//

import PagerTabStripView
import SwiftUI

struct PagerTabStripSampleView: View {
    @State private var query: String = ""

    var body: some View {
        VStack {
            SearchField(
                placeholderText: "入力してください",
                keyboardType: .default,
                text: $query
            ) { query in
                print(query)
            }
            .padding(.horizontal, 10)
            PagerTabStripView {
                MyFirstView()
                    .pagerTabItem(tag: 1) {
                        TitleNavBarItem(title: "テストタイトル")
                    }
                MySecondView()
                    .pagerTabItem(tag: 2) {
                        TitleNavBarItem(title: "テストタイトル")
                    }
                MyProfileView()
                    .pagerTabItem(tag: 3) {
                        TitleNavBarItem(title: "テストタイトル")
                    }
                MySecondView()
                    .pagerTabItem(tag: 4) {
                        TitleNavBarItem(title: "テストタイトル")
                    }
                MyProfileView()
                    .pagerTabItem(tag: 5) {
                        TitleNavBarItem(title: "テストタイトル")
                    }
            }
            .pagerTabStripViewStyle(
                .scrollableBarButton(
                    tabItemSpacing: 20,
                    tabItemHeight: 50,
                    indicatorView: {
                        Rectangle().fill(.gray).cornerRadius(5)
                    }
                )
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private struct MyFirstView: View {
        var body: some View {
            List {
                Text("最初の画面")
                    .frame(maxWidth: .infinity, minHeight: 2000)
                    .background(Color.blue)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
        }
    }

    private struct MySecondView: View {
        var body: some View {
            Text("最初の画面")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
        }
    }

    private struct MyProfileView: View {
        var body: some View {
            Text("最初の画面")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
        }
    }

    private struct TitleNavBarItem: View {
        let title: String

        var body: some View {
            VStack {
                Text(title)
                    .foregroundColor(Color.gray)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

#Preview {
    PagerTabStripSampleView()
}
