//
//  StickyHeaderTabView.swift
//  SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/07/05.
//

// 参考URL: https://techlife.cookpad.com/entry/2023/02/28/163645

import SwiftUI

private struct ScrollViewOffsetYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

public struct OffsetReadableVerticalScrollView<Content: View>: View {
    private struct CoordinateSpaceName: Hashable {}

    private let showsIndicators: Bool
    private let onChangeOffset: (CGFloat) -> Void
    private let content: () -> Content

    public init(
        showsIndicators: Bool = true,
        onChangeOffset: @escaping (CGFloat) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.onChangeOffset = onChangeOffset
        self.content = content
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            ZStack(alignment: .top) {
                GeometryReader { geometryProxy in
                    Color.clear.preference(
                        key: ScrollViewOffsetYPreferenceKey.self,
                        value: geometryProxy.frame(in: .named(CoordinateSpaceName())).minY
                    )
                }
                .frame(width: 1, height: 1)
                content()
            }
        }
        .coordinateSpace(name: CoordinateSpaceName())
        .onPreferenceChange(ScrollViewOffsetYPreferenceKey.self) { offset in
            onChangeOffset(offset)
        }
    }
}

struct StickyHeaderTabView: View {
    @State private var query: String = ""
    @State var selection: TabType  = .one
    @State private var offset: CGFloat = .zero

    private var topAreaHeight: CGFloat {
        80
    }

    enum TabType: String, CaseIterable, Identifiable {
        case one, two, three

        var id: String {
            self.rawValue
        }

        var color: Color {
            switch self {
            case .one: return Color.red
            case .two: return Color.orange
            case .three: return Color.blue
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            tabView

            VStack {
                SearchField(
                    placeholderText: "入力してください",
                    keyboardType: .default,
                    text: $query
                ) { query in
                    print(query)
                }
                .padding(.horizontal, 10)

                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            selection = .one
                        } label: {
                            Text("One")
                                .foregroundStyle(selection == .one ? .blue : .gray)
                        }
                        .frame(width: 140, height: 80)
                        Button {
                            selection = .two
                        } label: {
                            Text("Two")
                                .foregroundStyle(selection == .two ? .blue : .gray)
                        }
                        .frame(width: 140, height: 80)
                        Button {
                            selection = .three
                        } label: {
                            Text("Three")
                                .foregroundStyle(selection == .three ? .blue : .gray)
                        }
                        .frame(width: 140, height: 80)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    @ViewBuilder
    private var tabView: some View {
        TabView(selection: $selection) {
            ForEach(TabType.allCases) { tagType in
                OffsetReadableVerticalScrollView(onChangeOffset: updateOffset) {
                    Text("最初の画面")
                        .frame(maxWidth: .infinity, minHeight: 2000)
                        .background(tagType.color)
                        .listRowInsets(EdgeInsets())
                        .offset(y: -offset) // ④
                        .padding(.bottom, topAreaHeight)
                }
                .tag(tagType)
            }
        }
        .padding(.top, topAreaHeight)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }

    private func updateOffset(_ newOffset: CGFloat) { // ②
        if newOffset <= -80 { // HostingControllerを使わない場合、ここにsafeAreaを高さを足す必要がある。
            offset = -200
        } else if newOffset >= 0.0 {
            offset = 0
        } else {
            offset = newOffset
        }
    }
}

#Preview {
    StickyHeaderTabView()
}
