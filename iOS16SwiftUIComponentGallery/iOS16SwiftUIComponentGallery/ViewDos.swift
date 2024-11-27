//
//  ViewDos.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/11/27.
//

import SwiftUI

struct ViewDos: View {
    @EnvironmentObject var router: Router

    var body: some View {
        Text("Dos")

        Button("add Tres") {
            router.push(.tres)
        }
    }
}

class ViewDosModel: ObservableObject {
}

#Preview {
    ViewDos()
}
