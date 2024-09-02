import SwiftUI

struct PhotoPickerView: View {
    @State var image: UIImage?
    @State private var showImagePickerDialog = false
    @State private var showCamera: Bool = false
    @State private var showLibrary: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("写真を追加")

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                Button("削除する") {
                    self.image = nil
                }
            } else {
                Button("選択する") {
                    showImagePickerDialog = true
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraCaptureView(image: $image)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showLibrary, content: {
            PhotoLibraryPickerView(image: $image)
                .ignoresSafeArea()
        })
        .confirmationDialog(
            "",
            isPresented: $showImagePickerDialog,
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
                showImagePickerDialog = false
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}
