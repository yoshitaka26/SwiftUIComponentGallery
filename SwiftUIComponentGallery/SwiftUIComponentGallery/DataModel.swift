//
//  DataModel.swift
//  SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/07/10.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
}

@Observable
final class DataModel {
    var items: [Item] = [
        Item(title: "買い物", description: "野菜と果物を買う", date: Date().addingTimeInterval(86400)),
        Item(title: "ジム", description: "ウェイトトレーニング", date: Date().addingTimeInterval(172800)),
        Item(title: "読書", description: "新しい小説を読み始める", date: Date().addingTimeInterval(259200)),
        Item(title: "映画鑑賞", description: "友人と最新作を見に行く", date: Date().addingTimeInterval(345600)),
        Item(title: "料理", description: "新しいレシピに挑戦", date: Date().addingTimeInterval(432000)),
        Item(title: "散歩", description: "近所の公園を1時間歩く", date: Date().addingTimeInterval(518400)),
        Item(title: "勉強", description: "プログラミングの新しい技術を学ぶ", date: Date().addingTimeInterval(604800)),
        Item(title: "家の掃除", description: "リビングと寝室を徹底的に掃除", date: Date().addingTimeInterval(691200)),
        Item(title: "友人とランチ", description: "久しぶりの再会", date: Date().addingTimeInterval(777600)),
        Item(title: "ガーデニング", description: "新しい植物を植える", date: Date().addingTimeInterval(864000)),
        Item(title: "オンライン会議", description: "プロジェクトの進捗報告", date: Date().addingTimeInterval(950400)),
        Item(title: "楽器の練習", description: "ギターの新曲を練習", date: Date().addingTimeInterval(1036800)),
        Item(title: "写真撮影", description: "近所の風景を撮影", date: Date().addingTimeInterval(1123200)),
        Item(title: "ヨガ", description: "朝のヨガセッション", date: Date().addingTimeInterval(1209600)),
        Item(title: "言語学習", description: "フランス語の勉強", date: Date().addingTimeInterval(1296000)),
        Item(title: "ブログ執筆", description: "最新の技術トレンドについて", date: Date().addingTimeInterval(1382400)),
        Item(title: "車の整備", description: "オイル交換と点検", date: Date().addingTimeInterval(1468800)),
        Item(title: "ボランティア", description: "地域の清掃活動に参加", date: Date().addingTimeInterval(1555200)),
        Item(title: "家族との電話", description: "両親と近況報告", date: Date().addingTimeInterval(1641600)),
        Item(title: "美術館訪問", description: "新しい展示を見学", date: Date().addingTimeInterval(1728000)),
        Item(title: "靴の購入", description: "ランニングシューズを新調", date: Date().addingTimeInterval(1814400)),
        Item(title: "歯医者の予約", description: "定期健診の予約を入れる", date: Date().addingTimeInterval(1900800)),
        Item(title: "プレゼン準備", description: "来週の会議用資料作成", date: Date().addingTimeInterval(1987200)),
        Item(title: "財務計画", description: "月次予算の見直し", date: Date().addingTimeInterval(2073600)),
        Item(title: "ペットの世話", description: "犬の散歩と給餌", date: Date().addingTimeInterval(2160000)),
        Item(title: "旅行計画", description: "夏休みの旅行先を決める", date: Date().addingTimeInterval(2246400)),
        Item(title: "パソコンのバックアップ", description: "重要なファイルをバックアップ", date: Date().addingTimeInterval(2332800)),
        Item(title: "引越しの準備", description: "不要な物の整理", date: Date().addingTimeInterval(2419200)),
        Item(title: "料理教室", description: "イタリア料理の基礎を学ぶ", date: Date().addingTimeInterval(2505600)),
        Item(title: "健康診断", description: "年次健康診断の予約", date: Date().addingTimeInterval(2592000))
    ]
}
