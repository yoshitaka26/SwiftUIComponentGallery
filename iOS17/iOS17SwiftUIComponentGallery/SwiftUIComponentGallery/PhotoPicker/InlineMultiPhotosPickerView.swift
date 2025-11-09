import SwiftUI
import PhotosUI

struct InlineMultiPhotosPickerView: View {
    @StateObject private var viewModel = InlineMultiPhotosPickerViewModel()

    var body: some View {
        VStack {
            ImageList(viewModel: viewModel)

            PhotosPicker(
                selection: $viewModel.selection,
                selectionBehavior: .continuousAndOrdered,
                matching: .images,
                preferredItemEncoding: .current,
                photoLibrary: .shared()
            ) {
                Text("写真を選択")
            }

            // 半分の高さのPhotosピッカーを構成
            .photosPickerStyle(.compact)

            // インラインのユースケースでキャンセルボタンを無効にする
            .photosPickerDisabledCapabilities(.selectionActions)
            //                .photosPickerDisabledCapabilities(.search)
            //                .photosPickerDisabledCapabilities(.collectionNavigation)
            //                .photosPickerDisabledCapabilities(.stagingArea)

            // ピッカーUIのすべての端にあるアクセサリー（ツールバーなど）を非表示にする
            .photosPickerAccessoryVisibility(.hidden, edges: .all)
            .ignoresSafeArea()
            .frame(height: 300)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ImageList: View {
    @ObservedObject var viewModel: InlineMultiPhotosPickerViewModel

    var body: some View {
        if viewModel.attachments.isEmpty {
            Spacer()
            Image(systemName: "text.below.photo")
                .font(.system(size: 150))
                .opacity(0.2)
            Spacer()
        } else {
            List(viewModel.attachments) { imageAttachment in
                ImageAttachmentView(imageAttachment: imageAttachment)
            }
            .listStyle(.plain)
        }
    }
}

struct ImageAttachmentView: View {
    @ObservedObject var imageAttachment: InlineMultiPhotosPickerViewModel.ImageAttachment

    var body: some View {
        HStack {
            TextField("画像の説明", text: $imageAttachment.imageDescription)
            Spacer()

            switch imageAttachment.imageStatus {
            case .finished(let image):
                image.resizable().aspectRatio(contentMode: .fit).frame(height: 100)
            case .failed:
                Image(systemName: "exclamationmark.triangle.fill")
            default:
                ProgressView()
            }
        }.task {
            await imageAttachment.loadImage()
        }
    }
}

#Preview {
    InlineMultiPhotosPickerView()
}
