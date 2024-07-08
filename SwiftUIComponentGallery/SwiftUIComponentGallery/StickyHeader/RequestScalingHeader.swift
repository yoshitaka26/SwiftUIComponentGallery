//
//  RequestScalingHeader.swift
//  SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/07/04.
//

import SwiftUI
import ScalingHeaderScrollView

struct RequestScalingHeader: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var isLoading: Bool = false

    private let colorSet: [Color] = [.red, .blue, .green, .black, .pink, .purple, .yellow]
    @State private var displayedColors: [Color] = []

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScalingHeaderScrollView {
                ZStack {
                    Image("background")
                        .resizable()
                }
            } content: {
                VStack(alignment: .center) {

                    Divider()
                    Text("Squares")
                        .font(.largeTitle)
                        .padding()
                    scrollContent
                        .padding()
                }
                .padding()
            }
            .pullToRefresh(isLoading: $isLoading) {
                shuffleDataSource(delay: 3)
            }
            .pullToLoadMore(isLoading: $isLoading, contentOffset: 50) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    displayedColors += (0..<5).map { _ in colorSet.randomElement() ?? .red }
                    isLoading = false
                }
            }
            .height(min: 90.0, max: 250)
            .ignoresSafeArea()
            .onAppear {
                displayedColors = (0..<5).map { _ in colorSet.randomElement() ?? .red }
            }
        }
    }

    private func shuffleDataSource(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeIn(duration: 0.2)) {
                self.displayedColors.shuffle()
                self.isLoading = false
            }
        }
    }

    // MARK: - Private
    private var scrollContent: some View {
        LazyVStack {
            ForEach(Array(zip(displayedColors.indices, displayedColors)), id: \.0) { index, color in
                Rectangle()
                    .rotation(.degrees(45), anchor: .bottomLeading)
                    .scale(sqrt(2), anchor: .bottomLeading)
                    .frame(width: 200, height: 200)
                    .background(displayedColors.reversed()[index])
                    .foregroundColor(color)
                    .clipped()
            }
        }
    }
}

// プレビューではStickyHeaderの動作確認ができない
#Preview {
    RequestScalingHeader()
}
