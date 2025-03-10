import Foundation

class MyClass {
    // コンパイルエラー: Escaping closure captures non-escaping parameter 'completion'
    var storedClosure: (() -> Void)?

    func someMethod(completion: @escaping () -> Void) {
        storedClosure = completion // エラー：escapingが必要
    }

    func asyncOperation(completion: () -> Void) {
        // コンパイルエラー: Escaping closure captures non-escaping parameter 'completion'
        DispatchQueue.main.async {
            completion() // エラー：escapingが必要
        }
    }

    func passToAnotherMethod(callback: @escaping () -> Void) {
        // コンパイルエラー: Escaping closure captures non-escaping parameter 'callback'
        anotherMethod(completion: callback) // エラー：escapingが必要
    }

    func anotherMethod(completion: @escaping () -> Void) {
        // ...
    }

    func asyncOperation2(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            completion() // OK
        }
    }
}
