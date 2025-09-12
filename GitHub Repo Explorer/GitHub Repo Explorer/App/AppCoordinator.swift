//
//  AppCoordinator.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var selectedTab: MainTab = .repositories

    @Published var selectedRepositoryId: Int?

    enum MainTab {
        case repositories
        case favorites
    }

    /// Handle deep link URL
    func handleDeepLink(url: URL) {
        guard url.scheme == "ghre" else { return }

        // Example deeplink: ghre://repository/12345
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        guard let first = pathComponents.first else { return }

        switch first {
            case "repository":
                if pathComponents.count > 1, let repoId = Int(pathComponents[1]) {
                    // Navigate to repositories tab and show detail for repoId
                    selectedTab = .repositories
                    selectedRepositoryId = repoId
                }
            case "favorites":
                selectedTab = .favorites
            default:
                break
        }
    }
}
