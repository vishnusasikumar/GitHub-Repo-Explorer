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
    @ObservedObject var coordinator: AppCoordinator

    var favoriteRepos: [Repository] {
        viewModel.groupedRepositories.values
            .flatMap { $0 }
            .filter { favoritesManager.favorites.contains($0.id) }
    }

    var body: some View {
        VStack {
            Spacer()
            List {
                if favoriteRepos.isEmpty {
                    Text(Constants.Strings.noFavouritesTitle)
                        .foregroundColor(Constants.Colors.secondaryColor)
                } else {
                    ForEach(favoriteRepos) { repo in
                        Button {
                            coordinator.presentRepositoryDetail(id: repo.id)
                        } label: {
                            RepositoryRowView(repo: repo)
                        }
                    }
                }
            }
            .accessibilityIdentifier(Constants.Strings.favouritesList)
        }
    }
}

#Preview {
    FavoriteRepositoriesView(viewModel: DI.shared.resolve(),
                             favoritesManager: DI.shared.resolve(),
                             coordinator: DI.shared.resolve())
}
