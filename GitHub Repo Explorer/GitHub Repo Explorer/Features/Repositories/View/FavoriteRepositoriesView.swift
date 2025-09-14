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
        viewModel.groupedRepositories.values.flatMap { $0 }
            .filter { favoritesManager.favorites.contains($0.id) }
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            List {
                if favoriteRepos.isEmpty {
                    Text(Constants.Strings.noFavouritesTitle)
                        .foregroundColor(.secondary)
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
            .navigationTitle(Constants.Strings.favouritesTitle)
        }
        .accessibilityIdentifier(Constants.Strings.favouritesList)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: Binding(
            get: { coordinator.presentedRepositoryId },
            set: { newValue in coordinator.presentedRepositoryId = newValue }
        )) { repoId in
            if let url = viewModel.repositoryURL(for: repoId) {
                RepositoryDetailView(url: url, coordinator: coordinator)
            } else {
                ErrorView(errorMessage: Constants.Strings.repositoryDetailsErrorMessage,
                          errorDescription: Constants.Strings.errorDescription,
                          showRetry: false,
                          retryAction: {})
            }
        }
    }
}

#Preview {
    FavoriteRepositoriesView(viewModel: DI.shared.resolve(),
                             favoritesManager: DI.shared.resolve(),
                             coordinator: DI.shared.resolve())
}
