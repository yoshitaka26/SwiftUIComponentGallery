import SwiftUI
import PhotosUI

struct InlinePhotosPickerView: View {
    @StateObject private var viewModel = InlinePhotosPickerViewModel()

    var body: some View {
        VStack {
            ImageView(viewModel: viewModel)

            PhotosPicker(
                selection: $viewModel.imageSelection,
                matching: .images,
                preferredItemEncoding: .current,
                photoLibrary: .shared()
            ) {
                Text("Select Photos")
            }
            .photosPickerStyle(.inline)
            .photosPickerDisabledCapabilities(.selectionActions)
            .photosPickerAccessoryVisibility(.hidden, edges: .all)
            .ignoresSafeArea()
            .frame(height: 300)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ImageView: View {
    @ObservedObject var viewModel: InlinePhotosPickerViewModel

    var body: some View {
        if case .success(let image) = viewModel.imageState {
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
}
