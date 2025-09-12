//
//  FavoriteRepositoriesView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct FavoriteRepositoriesView: View {
    @ObservedObject var viewModel: RepositoryViewModel
    @ObservedObject var favoritesManager: FavoritesManager

    var favoriteRepos: [Repository] {
        viewModel.groupedRepositories.values.flatMap { $0 }.filter { favoritesManager.favorites.contains($0.id) }
    }

    var body: some View {
        NavigationView {
            List {
                if favoriteRepos.isEmpty {
                    Text(Constants.Strings.noFavouritesTitle)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(favoriteRepos) { repo in
                        RepositoryRowView(repo: repo)
                    }
                }
            }
            .accessibilityIdentifier(Constants.Strings.favouritesList)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(Constants.Strings.favouritesTitle)
        }
    }
}

#Preview {
    FavoriteRepositoriesView(viewModel: DI.shared.resolve(),
                             favoritesManager: DI.shared.resolve())
}
