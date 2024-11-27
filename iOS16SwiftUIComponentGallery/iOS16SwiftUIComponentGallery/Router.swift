//
//  Router.swift
//  iOS16SwiftUIComponentGallery
//
//  Created by Connehito262 on 2024/11/27.
//

import SwiftUI

class Router: ObservableObject {
    @Published var selection: Tab = .first
    @Published var tabFirstPath: NavigationPath = .init()
    @Published var tabSecondPath: NavigationPath = .init()
    @Published var tabThirdPath: NavigationPath = .init()

    func push(_ screen: Screen) {
        switch selection {
        case .first:
            tabFirstPath.append(screen)
        case .second:
            tabSecondPath.append(screen)
        case .third:
            tabThirdPath.append(screen)
        }
    }
}
