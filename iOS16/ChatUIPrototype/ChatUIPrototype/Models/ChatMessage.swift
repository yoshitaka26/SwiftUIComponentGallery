import SwiftUI
import Foundation

enum MessageType {
    case text(String)
    case image(String)
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: MessageType
    let sender: User
    let timestamp: Date
    let replyToId: UUID?
    
    init(content: MessageType, sender: User, timestamp: Date, replyToId: UUID? = nil) {
        self.content = content
        self.sender = sender
        self.timestamp = timestamp
        self.replyToId = replyToId
    }
    
    var displayText: String {
        switch content {
        case .text(let text):
            return text
        case .image:
            return "📷 画像"
        }
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var shouldScrollToBottom: Bool = false
    @Published var currentUser = User.currentUser
    let otherUsers = User.sampleUsers
    private var currentOtherUserIndex = 0
    
    func getMessageById(_ id: UUID?) -> ChatMessage? {
        guard let id = id else { return nil }
        return messages.first { $0.id == id }
    }
    
    init() {
        loadMockData()
    }
    
    private func generateLargeDataset() -> [ChatMessage] {
        var messages: [ChatMessage] = []
        var currentTime = Date().addingTimeInterval(-86400) // 1日前から開始
        var messagesByIndex: [Int: ChatMessage] = [:]
        
        let conversations = [
            // プロジェクトの計画について
            (otherUsers[0], "おはようございます！今日のミーティングの資料を共有します"),
            (otherUsers[1], "おはようございます。資料確認します"),
            (currentUser, "おはようございます！アジェンダを見ました"),
            (otherUsers[2], "今日は新プロジェクトのキックオフですね"),
            (otherUsers[0], "image:project-plan"),
            (otherUsers[0], "スケジュール表をアップしました"),
            (otherUsers[3], "タイムラインを確認しました。納期は3ヶ月後ですね"),
            
            // 朝食の話題
            (otherUsers[4], "朝ごはん何食べた？"),
            (currentUser, "トーストとコーヒーです"),
            (currentUser, "image:toast"),
            (otherUsers[1], "私はまだ..."),
            (otherUsers[0], "和食派です！納豆ご飯"),
            (otherUsers[0], "image:japanese-breakfast"),
            (otherUsers[5], "image:breakfast"),
            (otherUsers[2], "美味しそう！"),
            (otherUsers[4], "image:pancakes"),
            
            // 通勤の話題
            (otherUsers[6], "電車混んでる〜"),
            (otherUsers[6], "image:crowded-train"),
            (otherUsers[3], "月曜の朝は特に混みますよね"),
            (currentUser, "リモートワークできる日は助かります"),
            (otherUsers[0], "今日は在宅です！"),
            (otherUsers[0], "image:home-office"),
            (otherUsers[7], "いいなー"),
            
            // 仕事の話題
            (otherUsers[1], "今日締切のタスクがある..."),
            (otherUsers[4], "頑張って！"),
            (currentUser, "応援してます！"),
            (otherUsers[2], "私も手伝いますよ"),
            (otherUsers[1], "ありがとう！助かります"),
            
            // 昼食の相談
            (otherUsers[5], "そろそろランチの時間ですね"),
            (otherUsers[0], "何食べよう"),
            (currentUser, "近くに新しいラーメン屋ができたらしいです"),
            (otherUsers[3], "行きたい！"),
            (otherUsers[6], "image:ramen"),
            (otherUsers[1], "image:sushi"),
            (otherUsers[4], "image:curry"),
            (otherUsers[7], "美味しそう！"),
            (otherUsers[2], "みんなで行きましょう"),
            (currentUser, "image:restaurant"),
            
            // 午後の雑談
            (otherUsers[4], "眠くなってきた..."),
            (otherUsers[1], "わかる〜"),
            (currentUser, "コーヒーブレイクしましょう"),
            (otherUsers[0], "いいですね！"),
            (otherUsers[5], "甘いものも欲しい"),
            
            // 趣味の話
            (otherUsers[2], "週末何してた？"),
            (currentUser, "映画見に行きました"),
            (currentUser, "image:cinema"),
            (otherUsers[3], "何見たの？"),
            (currentUser, "新作のアクション映画です"),
            (otherUsers[3], "image:movie-poster"),
            (otherUsers[6], "面白かった？"),
            (currentUser, "最高でした！おすすめです"),
            (otherUsers[7], "今度一緒に行こう"),
            (otherUsers[7], "image:tickets"),
            
            // スポーツの話題
            (otherUsers[0], "昨日のサッカー見た？"),
            (otherUsers[0], "image:soccer-field"),
            (otherUsers[4], "見た！すごい試合だった"),
            (otherUsers[4], "image:stadium"),
            (otherUsers[1], "延長戦までいったよね"),
            (currentUser, "ハラハラしました"),
            (otherUsers[5], "次の試合も楽しみ"),
            (otherUsers[5], "image:sports"),
            
            // 買い物の話
            (otherUsers[2], "セール始まったらしいよ"),
            (otherUsers[2], "image:shopping-mall"),
            (otherUsers[3], "マジで！？"),
            (otherUsers[6], "何買う予定？"),
            (otherUsers[2], "服とか靴とか..."),
            (otherUsers[2], "image:clothes"),
            (currentUser, "私も行きたい！"),
            (otherUsers[7], "一緒に行こう"),
            (otherUsers[6], "image:shoes"),
            
            // 料理の話題
            (otherUsers[0], "今日の夕飯何にしよう"),
            (otherUsers[1], "カレーとか？"),
            (otherUsers[1], "image:curry-rice"),
            (otherUsers[4], "パスタもいいよね"),
            (currentUser, "image:pasta"),
            (otherUsers[0], "image:pizza"),
            (otherUsers[5], "美味しそう！レシピ教えて"),
            (currentUser, "簡単ですよ！"),
            (otherUsers[4], "image:cooking"),
            
            // ペットの話
            (otherUsers[2], "うちの猫が..."),
            (otherUsers[3], "どうしたの？"),
            (otherUsers[2], "image:cat"),
            (otherUsers[6], "かわいい〜！"),
            (otherUsers[7], "癒される"),
            (currentUser, "もふもふですね"),
            
            // 天気の話題
            (otherUsers[0], "明日雨らしいよ"),
            (otherUsers[0], "image:rain-cloud"),
            (otherUsers[1], "傘忘れないようにしないと"),
            (otherUsers[1], "image:umbrella"),
            (otherUsers[4], "洗濯物が..."),
            (currentUser, "部屋干しですね"),
            (otherUsers[2], "image:weather-forecast"),
            
            // 音楽の話
            (otherUsers[5], "新曲聴いた？"),
            (otherUsers[2], "まだ！どう？"),
            (otherUsers[5], "めっちゃいい！"),
            (otherUsers[3], "私も聴きたい"),
            (currentUser, "プレイリスト共有して"),
            (otherUsers[5], "OK！"),
            
            // ゲームの話題
            (otherUsers[6], "新作ゲーム買った人いる？"),
            (otherUsers[6], "image:gaming-console"),
            (otherUsers[7], "予約した！"),
            (otherUsers[7], "image:game-cover"),
            (otherUsers[0], "評判どう？"),
            (otherUsers[7], "レビュー高評価だよ"),
            (currentUser, "面白そう"),
            (currentUser, "image:gameplay"),
            
            // 勉強の話
            (otherUsers[1], "資格の勉強してる"),
            (otherUsers[4], "えらい！何の資格？"),
            (otherUsers[1], "TOEICです"),
            (currentUser, "頑張って！"),
            (otherUsers[2], "一緒に勉強会しよう"),
            
            // 旅行の計画
            (otherUsers[3], "夏休みどこ行く？"),
            (otherUsers[5], "沖縄行きたい"),
            (otherUsers[6], "いいね！"),
            (currentUser, "image:beach"),
            (otherUsers[7], "綺麗な海！"),
            (otherUsers[0], "みんなで行こう"),
            
            // 健康の話題
            (otherUsers[1], "最近運動不足..."),
            (otherUsers[4], "ジム行こうよ"),
            (otherUsers[4], "image:gym"),
            (currentUser, "ランニングもいいですよ"),
            (currentUser, "image:running"),
            (otherUsers[2], "ヨガ始めました"),
            (otherUsers[2], "image:yoga"),
            (otherUsers[3], "健康的！"),
            
            // 本の話
            (otherUsers[5], "おすすめの本ある？"),
            (otherUsers[6], "ミステリー好き？"),
            (otherUsers[5], "好き！"),
            (currentUser, "最近読んだ本が面白かったです"),
            (otherUsers[7], "タイトル教えて"),
            
            // カフェの話題
            (otherUsers[0], "新しいカフェ発見した"),
            (otherUsers[1], "どこ？"),
            (otherUsers[0], "駅の近く"),
            (otherUsers[4], "image:cafe"),
            (currentUser, "おしゃれ！"),
            (otherUsers[2], "今度行ってみる"),
            
            // 技術の話
            (otherUsers[3], "新しいスマホ出たね"),
            (otherUsers[3], "image:smartphone"),
            (otherUsers[5], "機能すごいらしい"),
            (otherUsers[6], "カメラが特に"),
            (otherUsers[6], "image:camera-lens"),
            (currentUser, "買い替え検討中"),
            (currentUser, "image:tech-gadgets"),
            (otherUsers[7], "私も！"),
            
            // イベントの話題
            (otherUsers[0], "来週のイベント参加する？"),
            (otherUsers[1], "何のイベント？"),
            (otherUsers[0], "フードフェス"),
            (otherUsers[0], "image:food-festival"),
            (currentUser, "行きたい！"),
            (otherUsers[4], "美味しいもの食べたい"),
            (otherUsers[4], "image:street-food"),
            (otherUsers[2], "image:festival-crowd"),
            
            // ファッションの話
            (otherUsers[2], "秋服買った"),
            (otherUsers[3], "見せて！"),
            (otherUsers[2], "image:fashion"),
            (otherUsers[5], "素敵！"),
            (currentUser, "どこで買ったの？"),
            
            // 植物の話題
            (otherUsers[6], "観葉植物育て始めた"),
            (otherUsers[6], "image:houseplants"),
            (otherUsers[7], "いいね！何育ててる？"),
            (otherUsers[6], "サボテンです"),
            (otherUsers[6], "image:cactus"),
            (otherUsers[0], "育てやすそう"),
            (currentUser, "私も欲しい"),
            (otherUsers[7], "image:succulent"),
            
            // 美容の話
            (otherUsers[1], "新しいコスメ買った"),
            (otherUsers[1], "image:cosmetics"),
            (otherUsers[4], "どこのブランド？"),
            (otherUsers[1], "話題の新作"),
            (otherUsers[1], "image:makeup-palette"),
            (otherUsers[2], "使い心地どう？"),
            (otherUsers[1], "すごくいい！"),
            (otherUsers[4], "image:lipstick"),
            
            // アートの話題
            (otherUsers[3], "美術館行ってきた"),
            (otherUsers[5], "どうだった？"),
            (otherUsers[3], "image:art"),
            (currentUser, "素晴らしい作品ですね"),
            (otherUsers[6], "感動的"),
            
            // お菓子の話
            (otherUsers[7], "新しいお菓子見つけた"),
            (otherUsers[7], "image:sweets"),
            (otherUsers[0], "美味しい？"),
            (otherUsers[7], "超おすすめ！"),
            (otherUsers[7], "image:chocolate"),
            (currentUser, "今度買ってみます"),
            (otherUsers[1], "私も！"),
            (otherUsers[0], "image:candy"),
            
            // 掃除の話題
            (otherUsers[4], "大掃除した"),
            (otherUsers[4], "image:clean-room"),
            (otherUsers[2], "すっきりした？"),
            (otherUsers[4], "めっちゃすっきり！"),
            (otherUsers[4], "image:organized-shelf"),
            (currentUser, "私もやらないと..."),
            (otherUsers[3], "一緒にやろう"),
            
            // 夜の挨拶
            (otherUsers[5], "そろそろ寝ます"),
            (otherUsers[5], "image:night-sky"),
            (otherUsers[6], "おやすみなさい"),
            (currentUser, "おやすみなさい！"),
            (otherUsers[7], "また明日〜"),
            (otherUsers[7], "image:moon"),
            (otherUsers[0], "良い夢を！"),
            (otherUsers[0], "image:stars"),
            (otherUsers[5], "今年のiOSDCも楽しいね〜〜"),
            (otherUsers[6], "わかる〜めっちゃ楽しい！"),
            (currentUser, "最高だね〜〜！"),
            (otherUsers[7], "明日最終日かぁ"),
            (otherUsers[7], "懇親会もあるよね！"),
            (otherUsers[0], "楽しみ〜〜🍻"),
            (otherUsers[1], "いいなぁ〜参加したい"),
            (otherUsers[4], "明日も楽しみ〜"),
            (currentUser, "ですね〜〜！"),
            (otherUsers[5], "iOSDC最高！"),
        ]
        
        // 各会話を3回繰り返して、異なる内容にする
        for round in 0..<3 {
            for (sender, content) in conversations {
                currentTime = currentTime.addingTimeInterval(Double.random(in: 30...180))
                
                let actualSender = sender == currentUser ? currentUser : sender
                
                // 返信先を決定（10%の確率で返信）
                var replyToId: UUID? = nil
                if !messages.isEmpty && Int.random(in: 1...10) <= 1 {
                    // 最近のメッセージから返信先を選択
                    let recentMessages = messages.suffix(min(20, messages.count))
                    replyToId = recentMessages.randomElement()?.id
                }
                
                if content.starts(with: "image:") {
                    let imageSeed = "\(content.dropFirst(6))-\(round)-\(Int.random(in: 1...10000))"
                    let newMessage = ChatMessage(
                        content: .image(imageSeed),
                        sender: actualSender,
                        timestamp: currentTime,
                        replyToId: replyToId
                    )
                    messages.append(newMessage)
                    messagesByIndex[messages.count - 1] = newMessage
                } else {
                    var modifiedContent = content
                    if round == 1 {
                        modifiedContent = content + " (続き)"
                    } else if round == 2 {
                        modifiedContent = content + "！"
                    }
                    
                    let newMessage = ChatMessage(
                        content: .text(modifiedContent),
                        sender: actualSender,
                        timestamp: currentTime,
                        replyToId: replyToId
                    )
                    messages.append(newMessage)
                    messagesByIndex[messages.count - 1] = newMessage
                }
            }
        }
        
        return messages
    }
    
    private func loadMockData() {
        messages = generateLargeDataset()
    }
    
    func sendMessage(text: String, replyToId: UUID? = nil) {
        let newMessage = ChatMessage(
            content: .text(text),
            sender: currentUser,
            timestamp: Date(),
            replyToId: replyToId
        )
        messages.append(newMessage)
        inputText = ""
        shouldScrollToBottom = true
        
        // デモ用の自動返信（ランダムなユーザーから）
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...2.0)) { [weak self] in
            guard let self = self else { return }
            
            let responses = [
                "なるほど、そうですね！",
                "興味深い話ですね。",
                "もう少し詳しく教えてください。",
                "了解しました！",
                "それはいいアイデアですね。",
                "私もそう思います！",
                "素晴らしい提案ですね。",
                "楽しそう！"
            ]
            let randomResponse = responses.randomElement() ?? "了解です。"
            let randomUser = self.otherUsers.randomElement() ?? self.otherUsers[0]
            
            // 20%の確率で返信として送信
            let shouldReply = Int.random(in: 1...5) == 1
            let replyToId = shouldReply && !self.messages.isEmpty ? self.messages.suffix(3).randomElement()?.id : nil
            
            let replyMessage = ChatMessage(
                content: .text(randomResponse),
                sender: randomUser,
                timestamp: Date(),
                replyToId: replyToId
            )
            self.messages.append(replyMessage)
            self.shouldScrollToBottom = true
            
            // 時々他のユーザーも反応
            if Bool.random() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5...1.5)) { [weak self] in
                    guard let self = self else { return }
                    let additionalResponses = ["私も！", "いいね！", "賛成です", "楽しみ！", "👍"]
                    let additionalUser = self.otherUsers.filter { $0.id != randomUser.id }.randomElement() ?? self.otherUsers[1]
                    
                    let additionalMessage = ChatMessage(
                        content: .text(additionalResponses.randomElement() ?? "いいね！"),
                        sender: additionalUser,
                        timestamp: Date(),
                        replyToId: nil
                    )
                    self.messages.append(additionalMessage)
                    self.shouldScrollToBottom = true
                }
            }
        }
    }
    
    func sendImage(replyToId: UUID? = nil) {
        let randomSeed = "user-upload-\(Int.random(in: 1...10000))"
        let newMessage = ChatMessage(
            content: .image(randomSeed),
            sender: currentUser,
            timestamp: Date(),
            replyToId: replyToId
        )
        messages.append(newMessage)
        shouldScrollToBottom = true
        
        // デモ用の自動返信で画像を送ることも
        if Bool.random() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.0...2.0)) { [weak self] in
                guard let self = self else { return }
                let randomUser = self.otherUsers.randomElement() ?? self.otherUsers[0]
                let randomImageSeed = "reply-\(Int.random(in: 1...10000))"
                
                let replyMessage = ChatMessage(
                    content: .image(randomImageSeed),
                    sender: randomUser,
                    timestamp: Date(),
                    replyToId: nil
                )
                self.messages.append(replyMessage)
                self.shouldScrollToBottom = true
            }
        }
    }
}

/*

 (otherUsers[0], "image:stars"),

 (otherUsers[5], "今年のiOSDCも楽しいね〜〜"),
 (otherUsers[5], "image:night-sky"),
 (otherUsers[6], "わかる〜めっちゃ楽しい！"),
 (currentUser, "最高だね〜〜！"),
 (otherUsers[7], "明日最終日かぁ"),
 (otherUsers[7], "懇親会もあるよね！"),
 (otherUsers[7], "image:moon"),
 (otherUsers[0], "楽しみ〜〜🍻"),
 (otherUsers[0], "image:stars"),
 (otherUsers[1], "いいなぁ〜参加したい"),
 (otherUsers[4], "明日も楽しみ〜"),
 (otherUsers[7], "image:moon"),
 (currentUser, "ですね〜〜！"),
 (otherUsers[5], "iOSDC最高！"),
 (otherUsers[7], "image:258"),
 */
