//
//  Item.swift
//  iOS18SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/11/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
