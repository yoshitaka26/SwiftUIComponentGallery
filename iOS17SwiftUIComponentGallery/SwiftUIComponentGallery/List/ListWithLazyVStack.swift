//
//  ListWithLazyVStack.swift
//  SwiftUIComponentGallery
//
//  Created by yoshitaka on 2024/07/10.
//

import SwiftUI

struct ListWithLazyVStack: View {
    @StateObject private var viewModel = DataModel()

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.items) { item in
                    VStack {
                        Text(item.title)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(item.description)
                            .font(.subheadline)
                    }
                    .background(Color.indigo.opacity(0.2))
                    .frame(height: 200)
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
        }
        .task {
            await viewModel.loadNextPage()
        }
        .refreshable {
            do {
                await viewModel.refresh()
                try await Task.sleep(nanoseconds: 5_000_000_000)
            } catch {}
        }
    }
}

#Preview {
    ListWithLazyVStack()
}
