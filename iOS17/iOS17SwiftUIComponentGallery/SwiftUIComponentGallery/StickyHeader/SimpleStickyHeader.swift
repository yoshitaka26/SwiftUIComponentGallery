//
//  SimpleStickyHeader.swift
//  SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/07/04.
//

import SwiftUI
import ScalingHeaderScrollView

struct SimpleStickyHeader: View {
    @Environment(\.presentationMode) var presentationMode

    @State var progress: CGFloat = 0.5

    @State private var selectedImage: String = "image_1"
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            ScalingHeaderScrollView {
                Image(selectedImage)
                    .resizable()
                    .scaledToFill()
            } content: {
                    Text("テスト")
                        .padding()
                        .frame(height: 1300)
            }
            .height(min: 100, max: 200)
            .headerSnappingPositions(snapPositions: [0, 0.5, 1])
            .initialSnapPosition(initialSnapPosition: 0.5)
            .collapseProgress($progress)
            .allowsHeaderGrowth()
            .allowsHeaderCollapse()
            .ignoresSafeArea()
        }
    }
}

// プレビューではStickyHeaderの動作確認ができない
#Preview {
    SimpleStickyHeader()
}
