//
//  GitHub_Repo_ExplorerApp.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

@main
struct GitHub_Repo_ExplorerApp: App {

    init() {
        // Register dependencies once at app startup
        RegisterDI.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .handlesExternalEvents(matching: ["ghre", "https"]) 
    }
}
