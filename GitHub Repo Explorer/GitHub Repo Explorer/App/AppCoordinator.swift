//
//  AppCoordinator.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    enum MainTab {
        case repositories
        case favorites
    }

    /// The currently selected tab
    @Published var selectedTab: MainTab = .repositories

    /// Stack-based navigation path for repositories
    @Published var path: [Int] = []

    @Published var presentedRepositoryId: Int? = nil

    // MARK: - Deep Linking

    /// Handle deep link URL
    func handleDeepLink(url: URL) {
        guard url.scheme == "ghre" else { return }

        // Example deeplink: ghre://search/repository/12345
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        guard let first = pathComponents.first else { return }

        switch first {
            case "repository":
                if pathComponents.count > 1, let repoId = Int(pathComponents[1]) {
                    selectedTab = .repositories
                    path = [repoId] // Navigate to repo detail via path
                }

            case "favorites":
                selectedTab = .favorites

            default:
                break
        }
    }

    /// Programmatic navigation to a repo
    func showRepositoryDetail(id: Int) {
        selectedTab = .repositories
        path = [id]
    }

    /// Clears navigation path
    func resetNavigation() {
        path.removeAll()
    }

    func presentRepositoryDetail(id: Int) {
        presentedRepositoryId = id
    }

    func dismissModal() {
        presentedRepositoryId = nil
    }
}

extension Int: @retroactive Identifiable {
    public var id: Int { self }
}
