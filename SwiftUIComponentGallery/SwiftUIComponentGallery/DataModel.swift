//
//  DataModel.swift
//  SwiftUIComponentGallery
//
//  Created by yoshitaka on 2024/07/10.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let sequentialId: Int
    let title: String
    let description: String
    let date: Date
}

@Observable
final class DataModel {
    private var allItems: [Item] = [
        Item(sequentialId: 1, title: "買い物", description: "野菜と果物を買う", date: Date().addingTimeInterval(86400)),
        Item(sequentialId: 2, title: "ジム", description: "ウェイトトレーニング", date: Date().addingTimeInterval(172800)),
        Item(sequentialId: 3, title: "読書", description: "新しい小説を読み始める", date: Date().addingTimeInterval(259200)),
        Item(sequentialId: 4, title: "映画鑑賞", description: "友人と最新作を見に行く", date: Date().addingTimeInterval(345600)),
        Item(sequentialId: 5, title: "料理", description: "新しいレシピに挑戦", date: Date().addingTimeInterval(432000)),
        Item(sequentialId: 6, title: "散歩", description: "近所の公園を1時間歩く", date: Date().addingTimeInterval(518400)),
        Item(sequentialId: 7, title: "勉強", description: "プログラミングの新しい技術を学ぶ", date: Date().addingTimeInterval(604800)),
        Item(sequentialId: 8, title: "家の掃除", description: "リビングと寝室を徹底的に掃除", date: Date().addingTimeInterval(691200)),
        Item(sequentialId: 9, title: "友人とランチ", description: "久しぶりの再会", date: Date().addingTimeInterval(777600)),
        Item(sequentialId: 10, title: "ガーデニング", description: "新しい植物を植える", date: Date().addingTimeInterval(864000)),
        Item(sequentialId: 11, title: "オンライン会議", description: "プロジェクトの進捗報告", date: Date().addingTimeInterval(950400)),
        Item(sequentialId: 12, title: "楽器の練習", description: "ギターの新曲を練習", date: Date().addingTimeInterval(1036800)),
        Item(sequentialId: 13, title: "写真撮影", description: "近所の風景を撮影", date: Date().addingTimeInterval(1123200)),
        Item(sequentialId: 14, title: "ヨガ", description: "朝のヨガセッション", date: Date().addingTimeInterval(1209600)),
        Item(sequentialId: 15, title: "言語学習", description: "フランス語の勉強", date: Date().addingTimeInterval(1296000)),
        Item(sequentialId: 16, title: "ブログ執筆", description: "最新の技術トレンドについて", date: Date().addingTimeInterval(1382400)),
        Item(sequentialId: 17, title: "車の整備", description: "オイル交換と点検", date: Date().addingTimeInterval(1468800)),
        Item(sequentialId: 18, title: "ボランティア", description: "地域の清掃活動に参加", date: Date().addingTimeInterval(1555200)),
        Item(sequentialId: 19, title: "家族との電話", description: "両親と近況報告", date: Date().addingTimeInterval(1641600)),
        Item(sequentialId: 20, title: "美術館訪問", description: "新しい展示を見学", date: Date().addingTimeInterval(1728000)),
        Item(sequentialId: 21, title: "靴の購入", description: "ランニングシューズを新調", date: Date().addingTimeInterval(1814400)),
        Item(sequentialId: 22, title: "歯医者の予約", description: "定期健診の予約を入れる", date: Date().addingTimeInterval(1900800)),
        Item(sequentialId: 23, title: "プレゼン準備", description: "来週の会議用資料作成", date: Date().addingTimeInterval(1987200)),
        Item(sequentialId: 24, title: "財務計画", description: "月次予算の見直し", date: Date().addingTimeInterval(2073600)),
        Item(sequentialId: 25, title: "ペットの世話", description: "犬の散歩と給餌", date: Date().addingTimeInterval(2160000)),
        Item(sequentialId: 26, title: "旅行計画", description: "夏休みの旅行先を決める", date: Date().addingTimeInterval(2246400)),
        Item(sequentialId: 27, title: "パソコンのバックアップ", description: "重要なファイルをバックアップ", date: Date().addingTimeInterval(2332800)),
        Item(sequentialId: 28, title: "引越しの準備", description: "不要な物の整理", date: Date().addingTimeInterval(2419200)),
        Item(sequentialId: 29, title: "料理教室", description: "イタリア料理の基礎を学ぶ", date: Date().addingTimeInterval(2505600)),
        Item(sequentialId: 30, title: "健康診断", description: "年次健康診断の予約", date: Date().addingTimeInterval(2592000))
    ]

    var items: [Item] = []
    var currentPage = 0
    let itemsPerPage = 10
    var isLoading = false

    func refresh() async {
        items = []
        currentPage = 0
        await loadNextPage()
    }

    func loadNextPage() async {
        guard !isLoading else { return }
        isLoading = true

        // APIリクエストをシミュレート
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
        } catch { }

        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, allItems.count)
        let newItems = Array(allItems[startIndex..<endIndex])

        items.append(contentsOf: newItems)
        currentPage += 1
        isLoading = false
    }

    var hasMorePages: Bool {
        if items.isEmpty {
            return false
        } else {
            return items.count < allItems.count
        }
    }
}
