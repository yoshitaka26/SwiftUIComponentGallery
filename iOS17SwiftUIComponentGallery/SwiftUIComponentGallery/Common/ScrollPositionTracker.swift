//
//  ScrollPositionTracker.swift
//  SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/07/11.
//

import SwiftUI

struct ScrollPositionTracker: View {
    @Binding var verticalOffset: CGFloat

    var body: some View {
        GeometryReader { geometry -> AnyView in
            let offset = -geometry.frame(in: .global).minY
            DispatchQueue.main.async {
                self.verticalOffset = offset
            }
            return AnyView(EmptyView())
        }
    }
}

enum VerticalScrollDirection {
    case up, down, none
}
