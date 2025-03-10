// https://qiita.com/st43/items/20d8b643c1f2431b4609

// Escaping closure captures non-escaping parameter 'completion'
// エスケープされたクロージャは、エスケープされていないパラメータ 'completion' を捕捉する。

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
    func load( completion: @escaping @Sendable (String) -> Void) {
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
