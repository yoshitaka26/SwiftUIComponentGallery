//
//  ChartList.swift
//  SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/06/29.
//

import SwiftUI
import Charts

struct ChartList: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    BasicBarChart()
                } label: {
                    VStack(alignment: .leading) {
                        Text("合計の売上")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("\(SalesData.last30DaysTotal, format: .number) 杯")
                            .font(.title2.bold())

                        Chart(SalesData.last30Days, id: \.day) {
                            BarMark(
                                x: .value("日", $0.day, unit: .day),
                                y: .value("売上", $0.sales)
                            )
                        }
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .frame(height: 100)
                    }
                }
            }

            Section {
                NavigationLink {
                    BasicSectorChart()
                } label: {
                    VStack(alignment: .leading) {
                        Text("1番売れた種類")
                            .foregroundStyle(.secondary)
                        Text(TopStyleData.last30Days.first!.name)
                            .font(.title2.bold())
                        Chart(TopStyleData.last30Days, id: \.name) { element in
                            SectorMark(
                                angle: .value("売上", element.sales),
                                innerRadius: .ratio(0.618),
                                angularInset: 1
                            )
                            .cornerRadius(3.0)
                            .foregroundStyle(by: .value("名前", element.name))
                            .opacity(element.name == TopStyleData.last30Days.first!.name ? 1 : 0.3)
                        }
                        .chartLegend(.hidden)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        .frame(height: 100)
                    }
                }
            }

            Section {
                NavigationLink {
                    BasicLineChart()
                } label: {
                    VStack(alignment: .leading) {
                        let symbolSize: CGFloat = 100
                        let lineWidth: CGFloat = 3

                        Text("日付と場所で1番売れた種類")
                            .foregroundStyle(.secondary)
                        Text("日曜日の新宿")
                            .font(.title2.bold())
                        Chart {
                            ForEach(LocationData.last30Days) { series in
                                ForEach(series.sales, id: \.day) { element in
                                    LineMark(
                                        x: .value("Day", element.day, unit: .day),
                                        y: .value("Sales", element.sales)
                                    )
                                }
                                .foregroundStyle(by: .value("City", series.city))
                                .symbol(by: .value("City", series.city))
                            }
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: lineWidth))
                            .symbolSize(symbolSize)

                            PointMark(
                                x: .value("Day", LocationData.last30DaysBest.weekday, unit: .day),
                                y: .value("Sales", LocationData.last30DaysBest.sales)
                            )
                            .foregroundStyle(.purple)
                            .symbolSize(symbolSize)
                        }
                        .chartForegroundStyleScale([
                            "Shibuya": .purple,
                            "Shinjuku": .green
                        ])
                        .chartSymbolScale([
                            "Shibuya": Circle().strokeBorder(lineWidth: lineWidth),
                            "Shinjuku": Square().strokeBorder(lineWidth: lineWidth)
                        ])
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { _ in
                                AxisTick()
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
                            }
                        }
                        .chartYAxis(.hidden)
                        .chartYScale(range: .plotDimension(endPadding: 8))
                        .chartLegend(.hidden)
                        .frame(height: 100)
                    }
                }
            }
        }
    }
}

struct Square: ChartSymbolShape, InsettableShape {
    let inset: CGFloat

    init(inset: CGFloat = 0) {
        self.inset = inset
    }

    func path(in rect: CGRect) -> Path {
        let cornerRadius: CGFloat = 1
        let minDimension = min(rect.width, rect.height)
        return Path(
            roundedRect: .init(x: rect.midX - minDimension / 2, y: rect.midY - minDimension / 2, width: minDimension, height: minDimension),
            cornerRadius: cornerRadius
        )
    }

    func inset(by amount: CGFloat) -> Square {
        Square(inset: inset + amount)
    }

    var perceptualUnitRect: CGRect {
        // The width of the unit rectangle (square). Adjust this to
        // size the diamond symbol so it perceptually matches with
        // the circle.
        let scaleAdjustment: CGFloat = 0.75
        return CGRect(x: 0.5 - scaleAdjustment / 2, y: 0.5 - scaleAdjustment / 2, width: scaleAdjustment, height: scaleAdjustment)
    }
}

#Preview {
    ChartList()
}
