//
//  SearchField.swift
//  SwiftUIComponentGallery
//
//  Created by yoshitaka on 2024/07/03.
//

import SwiftUI

struct SearchField: View {
    let placeholderText: String
    let keyboardType: UIKeyboardType

    @Binding var text: String
    @FocusState var isFocused: Bool

    let onUpdateSearchText: (String) -> Void

    var body: some View {
        HStack {
            ZStack {
                // 枠
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        Color.clear
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .strokeBorder(Color.gray, lineWidth: 1)
                    )
                    .frame(height: 36)

                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)

                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.gray)

                    TextField(placeholderText, text: $text)
                        .keyboardType(keyboardType)
                        .onReceive(
                            NotificationCenter.default
                                .publisher(for: UITextField.textDidChangeNotification)
                                .debounce(for: 0.5, scheduler: DispatchQueue.main),
                            perform: { notification in
                                if let textfield = notification.object as? UITextField {
                                    // 日本語変換中かどうか判定
                                    if textfield.markedTextRange == nil {
                                        onUpdateSearchText(text)
                                    }
                                }
                            }
                        )
                        .font(.system(size: 14))
                        .foregroundStyle(Color.primary)
                        .focused($isFocused)

                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray)
                        }
                        .padding(.trailing, 6)
                    }
                }
            }

            if isFocused {
                Button {
                    isFocused = false
                } label: {
                    Text("キャンセル")
                        .foregroundStyle(Color.primary)
                }
            }
        }
        .task {
            if #unavailable(iOS 16.0) {
                try? await Task.sleep(nanoseconds: NSEC_PER_SEC / 2)
            }
            isFocused = true
        }
    }
}

#Preview {
    SearchField(
        placeholderText: "入力",
        keyboardType: .default,
        text: .constant("")
    ) {
        print($0)
    }
}
