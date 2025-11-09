//
//  ListView.swift
//  SwiftUIComponentGallery
//
//  Created by yoshitaka on 2024/07/10.
//

import SwiftUI

struct ListView: View {
    @StateObject private var viewModel = DataModel()

    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    private let scrollThreshold: CGFloat = 30  // スクロール検知のしきい値

    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Color.clear
                    .overlay {
                        ScrollPositionTracker(verticalOffset: $scrollOffset)
                    }
                VStack {
                    Text(item.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text(item.description)
                        .font(.subheadline)
                }
                .listRowInsets(EdgeInsets())
                .background(Color.indigo.opacity(0.2))
                .frame(height: 100)
                .onAppear {
                    print("\(item.sequentialId):\(item.title) ✅appeared")
                }
                .onDisappear {
                    print("\(item.sequentialId):\(item.title) ❌disappeared")
                }
            }

            if viewModel.hasMorePages {
                ProgressView()
                    .onAppear {
                        print("🟠追加ローディング")
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                    .tint(Color.red)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
            }
        }
        .listRowSpacing(30)
        .background(Color.red)
        .listStyle(.plain)
        .task {
            await viewModel.loadNextPage()
        }
        .refreshable {
            do {
                await viewModel.refresh()
                try await Task.sleep(nanoseconds: 5_000_000_000)
            } catch {}
        }
        .onChange(of: scrollOffset) { newOffset in
            let delta = newOffset - previousScrollOffset
            if abs(delta) > scrollThreshold {
                let direction: VerticalScrollDirection = delta < 0 ? .up : .down
                print("###\(direction)")
            }
            previousScrollOffset = newOffset
        }
    }
}

#Preview {
    ListView()
}
