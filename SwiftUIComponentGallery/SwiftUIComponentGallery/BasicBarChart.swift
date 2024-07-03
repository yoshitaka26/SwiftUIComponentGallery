//
//  BasicBarChart.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import Charts

struct BasicBarChart: View {
    @State private var timeRange: TimeRange = .last30Days
    @State var scrollPositionStart =
        SalesData.last365Days.last!.day.addingTimeInterval(-1 * 3600 * 24 * 30)

    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 30)
    }

    var scrollPositionString: String {
        scrollPositionStart.formatted(.dateTime.month().day())
    }

    var scrollPositionEndString: String {
        scrollPositionEnd.formatted(.dateTime.month().day().year())
    }

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)

                Text("Total Sales")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                switch timeRange {
                case .last30Days:
                    Text("\(SalesData.salesInPeriod(in: scrollPositionStart...scrollPositionEnd), format: .number) Pancakes")
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    Text("\(scrollPositionString) – \(scrollPositionEndString)")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    Chart {
                        ForEach(SalesData.last365Days, id: \.day) {
                            BarMark(
                                x: .value("日", $0.day, unit: .day),
                                y: .value("売上", $0.sales)
                            )
                        }
                        .foregroundStyle(.blue)
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: 3600 * 24 * 30)
                    .chartScrollTargetBehavior(
                        .valueAligned(
                            matching: .init(hour: 0),
                            majorAlignment: .matching(.init(day: 1))))
                    .chartScrollPosition(x: $scrollPositionStart)
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 7)) {
                            AxisTick()
                            AxisGridLine()
                            AxisValueLabel(format: .dateTime.month().day())
                        }
                    }
                    .frame(height: 240)
                case .last12Months:
                    Text("\(SalesData.last12MonthsTotal, format: .number) 杯")
                        .font(.title2.bold())
                        .foregroundColor(.primary)

                    Chart(SalesData.last12Months, id: \.month) {
                        BarMark(
                            x: .value("月", $0.month, unit: .month),
                            y: .value("売上", $0.sales)
                        )
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
                        }
                    }
                    .frame(height: 240)
                }
            }
            .listRowSeparator(.hidden)
            .transaction {
                $0.animation = nil // Do not animate between different sets of bars.
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Total Sales", displayMode: .inline)
    }
}

#Preview {
    BasicBarChart()
}
