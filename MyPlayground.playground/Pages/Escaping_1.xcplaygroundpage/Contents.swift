// https://qiita.com/st43/items/20d8b643c1f2431b4609

// Capture of 'completion' with non-sendable type '(String) -> Void' in a `@Sendable` closure
// non-sendableな型 '(String) -> Void' を持つ 'completion' を `@Sendable` クロージャで捕捉する。

import UIKit

struct Translator {
    func translate(word: String) {
        let loader = Loader()
        loader.load {(string) in
            print(string)
        }
    }
}

struct Loader {
    func load(completion: (String) -> Void) {
        let request = URLRequest(url: URL(string: "https://qiita.com/")!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            // 本当はサーバーからのレスポンスを詰めているがサンプルコードなのでベタ書きする
            let string = "Hello"
            completion(string) // ここでコンパイルエラー
        }
        task.resume()
    }
}

let translator = Translator()
translator.translate(word: "こんにちは")

