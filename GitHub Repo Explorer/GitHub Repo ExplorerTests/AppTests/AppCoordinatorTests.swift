//
//  AppCoordinatorTests.swift
//  GitHub Repo ExplorerTests
//
//  Created by Admin on 14/09/2025.
//

import Testing
@testable import GitHub_Repo_Explorer
import Foundation

struct AppCoordinatorTests {
    @Test
    func test_initialState_isRepositoriesTab() {
        let coordinator = AppCoordinator()
        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_showRepositoryDetail_setsTabAndPath() {
        let coordinator = AppCoordinator()
        coordinator.showRepositoryDetail(id: 42)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path == [42])
    }

    @Test
    func test_resetNavigation_clearsPath() {
        let coordinator = AppCoordinator()
        coordinator.path = [101, 202]
        coordinator.resetNavigation()

        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_handleDeepLink_repository_setsTabAndPath() {
        let coordinator = AppCoordinator()
        let url = URL(string: "ghre://search/repository/12345")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path == [12345])
    }

    @Test
    func test_handleDeepLink_favorites_setsTabOnly() {
        let coordinator = AppCoordinator()
        let url = URL(string: "ghre://search/favorites")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .favorites)
        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_handleDeepLink_invalidScheme_doesNothing() {
        let coordinator = AppCoordinator()
        let url = URL(string: "https://search/repository/123")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_handleDeepLink_repository_missingID_doesNothing() {
        let coordinator = AppCoordinator()
        let url = URL(string: "ghre://search/repository")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_handleDeepLink_repository_invalidID_doesNothing() {
        let coordinator = AppCoordinator()
        let url = URL(string: "ghre://search/repository/notAnId")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path.isEmpty)
    }

    @Test
    func test_handleDeepLink_unknownPath_doesNothing() {
        let coordinator = AppCoordinator()
        let url = URL(string: "ghre://search/unknown/999")!

        coordinator.handleDeepLink(url: url)

        #expect(coordinator.selectedTab == .repositories)
        #expect(coordinator.path.isEmpty)
    }
}
