//
//  ViewUno.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/11/27.
//

import SwiftUI

struct ViewUno: View {
    @EnvironmentObject var router: Router

    var body: some View {
        Text("Uno")

        Button("add dos") {
            router.push(.dos)
        }
    }
}

#Preview {
    ViewUno()
}
