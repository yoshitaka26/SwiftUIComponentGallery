//
//  BasicLineChart.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import Charts

struct BasicLineChart: View {
    @State private var timeRange: TimeRange = .last30Days
    @State var rawSelectedDate: Date? = nil
    @State var rawSelectedRange: ClosedRange<Date>? = nil
    @Environment(\.calendar) var calendar
    @Environment(\.colorScheme) var colorScheme

    func endOfDay(for date: Date) -> Date {
        calendar.date(byAdding: .day, value: 1, to: date)!
    }

    var selectedDate: Date? {
        if let rawSelectedDate {
            return data.first?.sales.first(where: {
                let endOfDay = endOfDay(for: $0.day)

                return ($0.day ... endOfDay).contains(rawSelectedDate)
            })?.day
        } else if let selectedRange, selectedRange.lowerBound == selectedRange.upperBound {
            return selectedRange.lowerBound
        }

        return nil
    }

    var selectedRange: ClosedRange<Date>? {
        if let rawSelectedRange {
            let lower = data.first?.sales.first(where: {
                let endOfDay = endOfDay(for: $0.day)

                return ($0.day ... endOfDay).contains(rawSelectedRange.lowerBound)
            })?.day

            let upper = data.first?.sales.first(where: {
                let endOfDay = endOfDay(for: $0.day)

                return ($0.day ... endOfDay).contains(rawSelectedRange.upperBound)
            })?.day

            if let lower, let upper {
                return lower ... upper
            }
        }

        return nil
    }

    let colorPerCity: [String: Color] = [
        "Shibuya": .purple,
        "Shinjuku": .green
    ]

    var bestSales: (city: String, weekday: Date, sales: Int) {
        switch timeRange {
        case .last30Days:
            return LocationData.last30DaysBest
        case .last12Months:
            return LocationData.last12MonthsBest
        }
    }

    var data: [LocationData.Series] {
        switch timeRange {
        case .last30Days:
            return LocationData.last30Days
        case .last12Months:
            return LocationData.last12Months
        }
    }

    var descriptionText: Text {
        let sales = bestSales.sales.formatted(.number)
        let weekday = bestSales.weekday.formatted(.dateTime.weekday(.wide))
        let city = bestSales.city
        let time: String
        switch timeRange {
        case .last30Days:
            time = "30 日"
        case .last12Months:
            time = "12 月"
        }
        return Text("平均, \(sales) 杯の売上 \(weekday)曜日 \(city) にて過去 \(time).")
    }

    var title: some View {
        VStack(alignment: .leading) {
            Text("日付と場所で1番の売上")
                .font(preTitleFont)
                .foregroundStyle(.secondary)
            Text("日曜日の新宿")
                .font(titleFont)
        }
    }

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)

                VStack(alignment: .leading, spacing: 1) {
                    title
                    HStack {
                        HStack(spacing: 5) {
                            legendSquare
                            Text("Shinjuku")
                                .font(labelFont)
                                .foregroundStyle(.secondary)
                        }

                        HStack(spacing: 5) {
                            legendCircle
                            Text("Shibuya")
                                .font(labelFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .opacity(rawSelectedDate == nil && rawSelectedRange == nil ? 1.0 : 0.0)

                Spacer(minLength: 6)
                Chart {
                    ForEach(data) { series in
                        ForEach(series.sales, id: \.day) { element in
                            LineMark(
                                x: .value("Day", element.day, unit: .day),
                                y: .value("Sales", element.sales)
                            )
                        }
                        .foregroundStyle(by: .value("City", series.city))
                        .symbol(by: .value("City", series.city))
                        .interpolationMethod(.catmullRom)
                    }

                    if let selectedDate {
                        RuleMark(
                            x: .value("Selected", selectedDate, unit: .day)
                        )
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .annotation(
                            position: .top, spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) {
                            valueSelectionPopover
                        }
                    } else if let selectedRange {
                        Plot {
                            RuleMark(
                                x: .value("Selected upper bound", selectedRange.upperBound, unit: .day)
                            )
                            RuleMark(
                                x: .value("Selected lower bound", selectedRange.lowerBound, unit: .day)
                            )
                        }
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .offset(yStart: -10)
                        .zIndex(-1)
                        .annotation(
                            position: .top, spacing: 0,
                            overflowResolution: .init(
                                x: .fit(to: .chart),
                                y: .disabled
                            )
                        ) { context in
                            let markWidth = context.targetSize.width

                            rangeSelectionPopover
                                .frame(minWidth: markWidth > 0 ? markWidth : 0, alignment: .leading)
                                .fixedSize()
                                .padding(6)
                                .background {
                                    RoundedRectangle(cornerRadius: 4)
                                        .foregroundStyle(Color.gray.opacity(0.12))
                                }
                        }
                    }

                }
                .chartForegroundStyleScale { colorPerCity[$0]! }
                .chartSymbolScale([
                    "Shibuya": Circle().strokeBorder(lineWidth: 2),
                    "Shinjuku": Square().strokeBorder(lineWidth: 2)
                ])
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisTick()
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                    }
                }
                .chartLegend(.hidden)
                .chartXSelection(value: $rawSelectedDate)
                .chartXSelection(range: $rawSelectedRange)
                .frame(height: 240)

                Spacer(minLength: 15)
                descriptionText
                    .font(descriptionFont)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("日付と場所", displayMode: .inline)
        .scrollDisabled(true)
    }

    @ViewBuilder
    var valueSelectionPopover: some View {
        if let selectedDate,
           let salesPerCity = salesPerCity(on: selectedDate) {
            VStack(alignment: .leading) {
                Text("Average on \(selectedDate, format: .dateTime.weekday(.wide))s")
                    .font(preTitleFont)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                HStack(spacing: 20) {
                    ForEach(salesPerCity) { salesInfo in
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .lastTextBaseline, spacing: 4) {
                                Text("\(salesInfo.count, format: .number)")
                                    .font(titleFont)
                                    .foregroundColor(colorPerCity[salesInfo.city])
                                    .blendMode(colorScheme == .light ? .plusDarker : .normal)

                                    Text("売上")
                                        .font(preTitleFont)
                                        .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 6) {
                                if salesInfo.city == "Shinjuku" {
                                    legendCircle
                                } else {
                                    legendSquare
                                }
                                Text("\(salesInfo.city)")
                                    .font(labelFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(Color.gray.opacity(0.12))
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var rangeSelectionPopover: some View {
        if let selectedRange,
           let salesPerCity = averageSalesPerCity(in: selectedRange) {
            VStack(alignment: .leading) {
                Text("""
                    1日の平均 \
                    \(selectedRange.lowerBound, format: .dateTime.weekday(.wide))s – \
                    \(selectedRange.upperBound, format: .dateTime.weekday(.wide))s
                    """)
                    .font(preTitleFont)
                    .foregroundStyle(.secondary)
                    .fixedSize()
                HStack(spacing: 20) {
                    ForEach(salesPerCity) { salesInfo in
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .lastTextBaseline, spacing: 4) {
                                Text("\(salesInfo.count, format: .number)")
                                    .font(titleFont)
                                    .foregroundColor(colorPerCity[salesInfo.city])
                                    .blendMode(colorScheme == .light ? .plusDarker : .normal)

                                    Text("売上")
                                        .font(preTitleFont)
                                        .foregroundStyle(.secondary)
                            }
                            HStack(spacing: 6) {
                                if salesInfo.city == "Shinjuku" {
                                    legendCircle
                                } else {
                                    legendSquare
                                }
                                Text("\(salesInfo.city)")
                                    .font(labelFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }

    struct SaleCountPerCity: Identifiable {
        var city: String
        var count: Int
        var id: String { city }
    }

    func salesPerCity(on selectedDate: Date) -> [SaleCountPerCity]? {
        guard let index = data[0].sales.firstIndex(where: { day, sales in
            calendar.isDate(day, equalTo: selectedDate, toGranularity: .weekday)
        }) else {
            return nil
        }
        return data.map {
            SaleCountPerCity(city: $0.city, count: $0.sales[index].sales)
        }
    }

    func index(of selectedDate: Date) -> Int? {
        let firstCitySales = data[0].sales
        return firstCitySales.firstIndex(where: { day, sales in
            calendar.isDate(day, equalTo: selectedDate, toGranularity: .weekday)
        })
    }

    func averageSalesPerCity(in selectedRange: ClosedRange<Date>) -> [SaleCountPerCity]? {
        guard let lowerIndex = index(of: selectedRange.lowerBound),
              let upperIndex = index(of: selectedRange.upperBound) else {
            return nil
        }

        let dayCount = upperIndex - lowerIndex + 1
        return data.map {
            SaleCountPerCity(
                city: $0.city,
                count: $0.sales[lowerIndex...upperIndex].map(\.sales).reduce(0, +) / (dayCount))
        }
    }
}

@ViewBuilder
var legendSquare: some View {
    RoundedRectangle(cornerRadius: 1)
        .stroke(lineWidth: 2)
        .frame(width: 5.3, height: 5.3)
        .foregroundColor(.green)
        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0))
}

@ViewBuilder
var legendCircle: some View {
    Circle()
        .stroke(lineWidth: 2)
        .frame(width: 5.7, height: 5.7)
        .foregroundColor(.purple)
        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0))
}

var titleFont: Font = .title2.bold()
var preTitleFont: Font = .callout
var labelFont: Font = .caption2
var descriptionFont: Font = .subheadline

#Preview {
    BasicLineChart()
}
