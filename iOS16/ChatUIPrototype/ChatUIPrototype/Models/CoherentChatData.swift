import Foundation

extension ChatViewModel {
    func loadCoherentMockData() {
        var messages: [ChatMessage] = []
        var currentTime = Date().addingTimeInterval(-7200) // 2時間前から開始
        
        // プロジェクトチームのメンバー
        let teamLead = otherUsers[0]     // 田中（チームリーダー）
        let designer = otherUsers[1]      // 佐藤（デザイナー）
        let frontend = otherUsers[2]      // 鈴木（フロントエンド）
        let backend = otherUsers[3]       // 高橋（バックエンド）
        let qa = otherUsers[4]            // 山田（QA）
        let pm = otherUsers[5]            // 渡辺（PM）
        let marketing = otherUsers[6]     // 伊藤（マーケティング）
        let support = otherUsers[7]       // 中村（サポート）
        
        // 会話の流れ（Webアプリ開発プロジェクトについて）
        let coherentConversations: [(User, String)] = [
            // プロジェクトキックオフ
            (teamLead, "おはようございます！本日10時からECサイトリニューアルプロジェクトのキックオフミーティングを開始します"),
            (pm, "おはようございます。資料を共有します"),
            (pm, "image:project-document"),
            (designer, "おはようございます。デザインモックアップの準備できています"),
            (currentUser, "おはようございます！開発環境の準備完了しています"),
            (backend, "APIの仕様書も用意しました"),
            (frontend, "フロントエンドのフレームワークはNext.jsで進めます"),
            (qa, "テスト計画書のドラフトを作成しました"),
            
            // 要件確認
            (pm, "まず、主要な要件を確認しましょう"),
            (pm, "1. レスポンシブデザイン対応"),
            (pm, "2. 決済システムの統合"),
            (pm, "3. 在庫管理システムとの連携"),
            (teamLead, "技術スタックも確認します"),
            (backend, "バックエンドはNode.js + TypeScript + PostgreSQLで構築します"),
            (frontend, "フロントエンドはNext.js + TypeScript + Tailwind CSSです"),
            (currentUser, "状態管理はZustandを使用予定です"),
            
            // デザイン議論
            (designer, "デザインコンセプトを共有します"),
            (designer, "image:design-mockup"),
            (designer, "ミニマルでモダンなUIを目指しています"),
            (marketing, "ターゲット層は20-40代の働く世代ですね"),
            (frontend, "このデザインなら実装可能です。アニメーションも追加できそう"),
            (currentUser, "カラーパレットはアクセシビリティ基準を満たしていますか？"),
            (designer, "はい、WCAG 2.1のAAレベルをクリアしています"),
            
            // 技術的な課題
            (backend, "決済システムのAPIについて相談があります"),
            (backend, "Stripeを使う予定ですが、他の選択肢も検討すべきでしょうか"),
            (pm, "予算とセキュリティ要件を考慮するとStripeが最適だと思います"),
            (qa, "Stripeのテスト環境も充実していますね"),
            (support, "カスタマーサポートの観点からもStripeは扱いやすいです"),
            
            // スケジュール調整
            (teamLead, "スケジュールを確認しましょう"),
            (pm, "image:gantt-chart"),
            (pm, "フェーズ1は基本機能の実装で3週間"),
            (pm, "フェーズ2は決済システム統合で2週間"),
            (pm, "フェーズ3はテストと修正で2週間"),
            (backend, "APIの開発は今週から開始できます"),
            (frontend, "UIコンポーネントの開発も並行して進められます"),
            (currentUser, "共通コンポーネントから着手しましょう"),
            
            // データベース設計
            (backend, "データベーススキーマの設計を共有します"),
            (backend, "image:database-schema"),
            (teamLead, "正規化はしっかりされていますね"),
            (qa, "パフォーマンステストも計画に入れましょう"),
            (backend, "インデックスの設計も重要ですね"),
            (currentUser, "キャッシュ戦略も検討が必要です"),
            
            // セキュリティ対策
            (teamLead, "セキュリティ要件も確認しましょう"),
            (backend, "SQLインジェクション対策はORMで対応"),
            (frontend, "XSS対策はReactがデフォルトで処理してくれます"),
            (qa, "ペネトレーションテストも実施予定です"),
            (support, "個人情報の取り扱いについてプライバシーポリシーも更新が必要です"),
            
            // UI/UX改善提案
            (designer, "ユーザビリティテストの結果を共有します"),
            (designer, "image:usability-test"),
            (designer, "カート画面の離脱率が高いことが判明しました"),
            (marketing, "簡潔なチェックアウトフローが必要ですね"),
            (frontend, "ワンクリック購入機能も検討しましょう"),
            (currentUser, "プログレスインジケーターを追加すると良いかもしれません"),
            
            // パフォーマンス最適化
            (frontend, "Lighthouseスコアを改善したいです"),
            (frontend, "image:lighthouse-score"),
            (backend, "APIのレスポンスタイムも最適化します"),
            (currentUser, "画像の遅延読み込みを実装しましょう"),
            (designer, "画像フォーマットはWebPを使用します"),
            (qa, "負荷テストのシナリオも準備します"),
            
            // モバイル対応
            (designer, "モバイルファーストで設計しています"),
            (frontend, "タッチ操作の最適化も重要ですね"),
            (currentUser, "スワイプジェスチャーも実装できます"),
            (marketing, "モバイルユーザーが全体の70%を占めています"),
            (support, "モバイルアプリも将来的に検討すべきかもしれません"),
            
            // 国際化対応
            (pm, "将来的な海外展開も視野に入れています"),
            (backend, "多言語対応のAPIを設計します"),
            (frontend, "i18nライブラリを導入しましょう"),
            (currentUser, "通貨と日付フォーマットの対応も必要です"),
            (designer, "RTL（右から左）言語のレイアウトも考慮します"),
            
            // テスト戦略
            (qa, "テスト戦略を説明します"),
            (qa, "単体テスト、統合テスト、E2Eテストを実施"),
            (frontend, "JestとReact Testing Libraryを使用します"),
            (backend, "バックエンドはMochaとChaiです"),
            (currentUser, "カバレッジ目標は80%以上にしましょう"),
            
            // CI/CDパイプライン
            (teamLead, "CI/CDパイプラインの構築も重要です"),
            (backend, "GitHub ActionsでCI/CDを設定します"),
            (frontend, "プルリクエストごとに自動テストを実行"),
            (qa, "ステージング環境への自動デプロイも設定しましょう"),
            (currentUser, "Dockerコンテナを使用して環境を統一します"),
            
            // ドキュメント作成
            (teamLead, "ドキュメントの作成も忘れずに"),
            (backend, "API仕様書はOpenAPIで管理します"),
            (frontend, "Storybookでコンポーネントカタログを作成"),
            (designer, "デザインシステムのドキュメントも準備します"),
            (currentUser, "READMEとセットアップガイドを充実させましょう"),
            
            // リスク管理
            (pm, "リスク管理についても話し合いましょう"),
            (teamLead, "技術的負債を最小限に抑える必要があります"),
            (qa, "リグレッションテストの自動化が重要です"),
            (backend, "依存関係の定期的な更新も必要"),
            (support, "ユーザーフィードバックの収集体制も整えましょう"),
            
            // 進捗確認
            (pm, "今週の進捗を確認します"),
            (backend, "認証APIの実装が完了しました"),
            (frontend, "ログイン画面とダッシュボードが完成"),
            (designer, "商品詳細ページのデザインが承認されました"),
            (currentUser, "カート機能の実装を開始しました"),
            (qa, "テストケースの作成が50%完了"),
            
            // コードレビュー
            (teamLead, "コードレビューのプロセスを確認します"),
            (backend, "プルリクエストには最低2人のレビューが必要"),
            (frontend, "コーディング規約に従っているか確認"),
            (currentUser, "自動フォーマッターとリンターを設定済みです"),
            (qa, "レビュー時にテストカバレッジも確認しましょう"),
            
            // デモ準備
            (pm, "来週のステークホルダー向けデモの準備をしましょう"),
            (designer, "デモ用のダミーデータを用意します"),
            (frontend, "主要な機能フローを確認できるようにします"),
            (backend, "APIは安定版を使用します"),
            (currentUser, "デモ環境をセットアップします"),
            
            // フィードバック対応
            (marketing, "初期ユーザーからのフィードバックを共有します"),
            (marketing, "検索機能の改善要望が多いです"),
            (backend, "全文検索エンジンの導入を検討しましょう"),
            (frontend, "検索UIも改善が必要ですね"),
            (designer, "オートコンプリート機能も追加しましょう"),
            
            // 最終確認
            (teamLead, "本日のミーティングをまとめます"),
            (pm, "アクションアイテムを確認しましょう"),
            (pm, "image:action-items"),
            (teamLead, "次回は水曜日の進捗確認ミーティングです"),
            (backend, "了解しました。APIの実装を進めます"),
            (frontend, "UIの実装を継続します"),
            (designer, "残りのページデザインを完成させます"),
            (currentUser, "カート機能の実装を完了させます"),
            (qa, "テストケースの作成を続けます"),
            (support, "ドキュメントの準備を進めます"),
            (marketing, "マーケティング戦略を詳細化します"),
            (pm, "お疲れ様でした！良いプロジェクトにしましょう！")
        ]
        
        // メッセージを生成
        for (sender, content) in coherentConversations {
            currentTime = currentTime.addingTimeInterval(Double.random(in: 15...60))
            
            let messageContent: MessageType
            if content.starts(with: "image:") {
                let imageSeed = String(content.dropFirst(6))
                messageContent = .image(imageSeed)
            } else {
                messageContent = .text(content)
            }
            
            // 10%の確率で返信にする
            var replyToId: UUID? = nil
            if !messages.isEmpty && Int.random(in: 1...10) == 1 {
                let recentMessages = messages.suffix(min(10, messages.count))
                replyToId = recentMessages.randomElement()?.id
            }
            
            let message = ChatMessage(
                content: messageContent,
                sender: sender,
                timestamp: currentTime,
                replyToId: replyToId
            )
            messages.append(message)
        }
        
        self.messages = messages
    }
}