import SwiftUI
import PhotosUI

@MainActor final class InlineMultiPhotosPickerViewModel: ObservableObject {
    @MainActor final class ImageAttachment: ObservableObject, Identifiable {

        /// 選択された写真の読み込み進捗を示すステータス
        enum Status {
            case loading
            case finished(Image)
            case failed(Error)

            var isFailed: Bool {
                return switch self {
                case .failed: true
                default: false
                }
            }
        }

        /// 写真の読み込みに失敗した理由を示すエラー
        enum LoadingError: Error {
            case contentTypeNotSupported
        }

        /// ピッカーで選択された写真への参照
        private let pickerItem: PhotosPickerItem

        /// 写真の読み込み進捗
        @Published var imageStatus: Status?

        /// 写真のテキスト説明
        @Published var imageDescription: String = ""

        /// 写真の識別子
        nonisolated var id: String {
            pickerItem.identifier
        }

        /// 指定されたピッカーアイテムの画像添付を作成する
        init(_ pickerItem: PhotosPickerItem) {
            self.pickerItem = pickerItem
        }

        /// ピッカーアイテムが特徴とする写真を読み込む
        func loadImage() async {
            guard imageStatus == nil || imageStatus?.isFailed == true else {
                return
            }
            imageStatus = .loading
            do {
                if let data = try await pickerItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    imageStatus = .finished(Image(uiImage: uiImage))
                } else {
                    throw LoadingError.contentTypeNotSupported
                }
            } catch {
                imageStatus = .failed(error)
            }
        }
    }

    /// ピッカーで選択された写真のアイテムの配列
    ///
    /// セット時、このメソッドは現在の選択の画像添付を更新する
    @Published var selection = [PhotosPickerItem]() {
        didSet {
            // 現在のピッカー選択に応じて添付を更新する
            let newAttachments = selection.map { item in
                // 既存の添付が存在する場合はアクセスし、そうでない場合は新しい添付を作成する
                attachmentByIdentifier[item.identifier] ?? ImageAttachment(item)
            }
            // スコープ内で読み込まれた新しい添付に対して保存された添付配列を更新する
            let newAttachmentByIdentifier = newAttachments.reduce(into: [:]) { partialResult, attachment in
                partialResult[attachment.id] = attachment
            }
            // 非同期アクセスをサポートするために、既存の配列を更新するのではなく、新しい配列をインスタンスプロパティに割り当てる
            attachments = newAttachments
            attachmentByIdentifier = newAttachmentByIdentifier
        }
    }

    /// ピッカーで選択された写真の画像添付の配列
    @Published var attachments = [ImageAttachment]()

    /// パフォーマンスのために以前に読み込まれた添付を保存する辞書
    private var attachmentByIdentifier = [String: ImageAttachment]()
}

/// ピッカーアイテムにフォトライブラリがない場合の状況を処理する拡張
private extension PhotosPickerItem {
    var identifier: String {
        guard let identifier = itemIdentifier else {
            fatalError("Photosピッカーにフォトライブラリがありません。")
        }
        return identifier
    }
}
