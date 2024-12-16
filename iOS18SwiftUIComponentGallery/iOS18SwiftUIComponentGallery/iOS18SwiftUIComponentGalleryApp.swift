//
//  iOS18SwiftUIComponentGalleryApp.swift
//  iOS18SwiftUIComponentGallery
//
//  Created by Yoshitaka Tanaka on 2024/11/23.
//

import SwiftUI
import SwiftData

@main
struct iOS18SwiftUIComponentGalleryApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
