import SwiftUI
import PhotosUI

struct ProfilePhotoPickerView: View {
    @StateObject var viewModel = ProfilePhotoPickerViewModel()

    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    EditableCircularProfileImage(viewModel: viewModel)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)

            Section {
                TextField("First Name",
                          text: $viewModel.firstName,
                          prompt: Text("First Name"))
                TextField("Last Name",
                          text: $viewModel.lastName,
                          prompt: Text("Last Name"))
            }
            Section {
                TextField("About Me",
                          text: $viewModel.aboutMe,
                          prompt: Text("About Me"))
            }
        }
        .navigationTitle("Account Profile")
    }
}

struct ProfileImage: View {
    let imageState: ProfilePhotoPickerViewModel.ImageState

    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct CircularProfileImage: View {
    let imageState: ProfilePhotoPickerViewModel.ImageState

    var body: some View {
        ProfileImage(imageState: imageState)
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .background {
                Circle().fill(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
    }
}

struct EditableCircularProfileImage: View {
    @ObservedObject var viewModel: ProfilePhotoPickerViewModel

    var body: some View {
        CircularProfileImage(imageState: viewModel.imageState)
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(selection: $viewModel.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.borderless)
            }
    }
}

#Preview {
    ProfilePhotoPickerView()
}
