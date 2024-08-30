import SwiftUI

struct PhotoPickerView: View {
    @State private var showImagePicker = false
    @State var image: UIImage?
    @State private var showCamera: Bool = false
    @State private var showLibrary: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            Text("写真を追加")

            Button("選択する") {
                showImagePicker = true
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView(image: $image)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showLibrary, content: {
            ImagePickerView(image: $image)
        })
        .confirmationDialog(
            "",
            isPresented: $showImagePicker,
            titleVisibility: .hidden
        ) {
            Button {
                showCamera = true
            } label: {
                Text("カメラで撮る")
            }
            Button {
                showLibrary = true
            } label: {
                Text("アルバムから選ぶ")
            }
            Button("キャンセル", role: .cancel) {
                showImagePicker = false
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}
