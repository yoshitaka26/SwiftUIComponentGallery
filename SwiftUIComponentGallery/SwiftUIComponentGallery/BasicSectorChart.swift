//
//  BasicSectorChart.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import Charts

struct BasicSectorChart: View {
    @State private var timeRange: TimeRange = .last30Days
    @State var selectedSales: Double? = nil

    var cumulativeSalesRangesForStyles: [(name: String, range: Range<Double>)] {
        var cumulative = 0.0
        return data.map {
            let newCumulative = cumulative + Double($0.sales)
            let result = (name: $0.name, range: cumulative ..< newCumulative)
            cumulative = newCumulative
            return result
        }
    }

    var mostSold: (name: String, sales: Int) {
        self.data.first ?? (name: "Unknown", sales: 0)
    }

    var data: [(name: String, sales: Int)] {
        switch timeRange {
        case .last12Months:
            return TopStyleData.last12Months
        case .last30Days:
            return TopStyleData.last12Months.map { (name, _) in
                // Keep the annual order for consistent sector ordering.
                return (
                    name: name,
                    sales: TopStyleData.last30Days.first(where: { $0.name == name })?.sales ?? 0
                )
            }
        }
    }

    var selectedStyle: (name: String, sales: Int)? {
        if let selectedSales,
           let selectedIndex = cumulativeSalesRangesForStyles
            .firstIndex(where: { $0.range.contains(selectedSales) }) {
            return data[selectedIndex]
        }

        return nil
    }

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)
                    .transaction {
                        $0.animation = nil // Do not animate the picker.
                    }

                Chart(data, id: \.name) { element in
                    SectorMark(
                        angle: .value("売上", element.sales),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .cornerRadius(5.0)
                    .foregroundStyle(by: .value("名前", element.name))
                    .opacity(element.name == (selectedStyle?.name ?? mostSold.name) ? 1 : 0.3)
                }
                .chartLegend(alignment: .center, spacing: 18)
                .chartAngleSelection(value: $selectedSales)
                .scaledToFit()
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        let frame = geometry[chartProxy.plotFrame!]
                        VStack {
                            Text("1番の売上")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .opacity(selectedStyle == nil || selectedStyle?.name == mostSold.name ? 1 : 0)
                            Text(selectedStyle?.name ?? mostSold.name)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                            Text((selectedStyle?.sales.formatted() ?? mostSold.sales.formatted()) + " 販売")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("種類", displayMode: .inline)
    }
}

#Preview {
    BasicSectorChart()
}
