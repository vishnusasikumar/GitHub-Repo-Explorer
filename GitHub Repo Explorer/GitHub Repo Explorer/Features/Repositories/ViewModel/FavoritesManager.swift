//
//  FavoritesManager.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: Set<Int> = []

    private let key = "favoriteRepoIDs"

    init() {
        load()
    }

    func isFavorited(_ repo: Repository) -> Bool {
        favorites.contains(repo.id)
    }

    func toggleFavorite(_ repo: Repository) {
        if favorites.contains(repo.id) {
            favorites.remove(repo.id)
        } else {
            favorites.insert(repo.id)
        }
        save()
    }

    private func load() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [Int] {
            favorites = Set(saved)
        }
    }

    private func save() {
        UserDefaults.standard.set(Array(favorites), forKey: key)
    }
}
