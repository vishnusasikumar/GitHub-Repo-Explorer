//
//  FavoritesManagerTests.swift
//  GitHub Repo ExplorerTests
//
//  Created by Admin on 14/09/2025.
//

import Testing
@testable import GitHub_Repo_Explorer
import Foundation

final class MockUserDefaults: UserDefaults {
    private var store: [String: Any] = [:]

    override func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }

    override func array(forKey defaultName: String) -> [Any]? {
        return store[defaultName] as? [Any]
    }

    override func object(forKey defaultName: String) -> Any? {
        return store[defaultName]
    }

    override func removeObject(forKey defaultName: String) {
        store.removeValue(forKey: defaultName)
    }
}

struct FavoritesManagerTests {
    private let testKey = "favoriteRepoIDs"

    // Sample repositories for testing
    private var repo1: Repository {
        Repository(
            id: 1,
            name: "TestRepo1",
            fullName: nil,
            owner: .init(login: "user", avatarUrl: "", type: "User"),
            language: nil,
            url: nil,
            stargazersCount: nil,
            updatedAt: nil,
            createdAt: "2022-01-01T00:00:00Z",
            allowForking: true
        )
    }

    private var repo2: Repository {
        Repository(
            id: 2,
            name: "TestRepo2",
            fullName: nil,
            owner: .init(login: "org", avatarUrl: "", type: "Organization"),
            language: nil,
            url: nil,
            stargazersCount: nil,
            updatedAt: nil,
            createdAt: "2022-01-01T00:00:00Z",
            allowForking: false
        )
    }

    // MARK: - Tests

    @Test
    func test_toggleFavorite_addsAndRemovesCorrectly() {
        let mockDefaults = MockUserDefaults()
        let manager = FavoritesManager(userDefaults: mockDefaults)

        manager.toggleFavorite(repo1)
        #expect(manager.isFavorited(repo1) == true)

        manager.toggleFavorite(repo1)
        #expect(manager.isFavorited(repo1) == false)
    }

    @Test
    func test_loadFromUserDefaults_setsFavorites() {
        let mockDefaults = MockUserDefaults()
        mockDefaults.set([1, 2], forKey: "favoriteRepoIDs")

        let manager = FavoritesManager(userDefaults: mockDefaults)
        #expect(manager.favorites == [1, 2])
    }

    @Test
    func test_saveToUserDefaults_persistsData() {
        let mockDefaults = MockUserDefaults()
        let manager = FavoritesManager(userDefaults: mockDefaults)

        manager.toggleFavorite(repo2)

        let saved = mockDefaults.array(forKey: "favoriteRepoIDs") as? [Int]
        #expect(saved?.contains(2) == true)
    }

    @Test
    func test_isFavorited_returnsCorrectValue() {
        let mockDefaults = MockUserDefaults()
        let manager = FavoritesManager(userDefaults: mockDefaults)

        manager.toggleFavorite(repo1)
        #expect(manager.isFavorited(repo1) == true)
        #expect(manager.isFavorited(repo2) == false)
    }
}
