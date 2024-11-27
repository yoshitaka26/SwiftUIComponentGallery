//
//  Screen.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/11/27.
//

import SwiftUI

enum Screen: Equatable {
    case uno
    case dos
    case tres

    @ViewBuilder
    func view() -> some View{
        switch self {
        case .uno: ViewUno()
        case .dos: ViewDos()
        case .tres: ViewTres()
        }
    }
}
