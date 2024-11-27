//
//  ViewTres.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/11/27.
//

import SwiftUI

struct ViewTres: View {
    @EnvironmentObject var router: Router

    var body: some View {
        Text("Tres")

        Button("add Uno") {
            router.push(.uno)
        }
    }
}

#Preview {
    ViewTres()
}
