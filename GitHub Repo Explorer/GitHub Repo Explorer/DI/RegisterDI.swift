//
//  RegisterDI.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

final class RegisterDI {
    @MainActor
    static func register() {
        let apiService: GitHubServiceProtocol = APIEnvironment.resolve()

        // Register API client in DI
        DI.shared.register(GitHubServiceProtocol.self, apiService as GitHubServiceProtocol)
        DI.shared.register(AppCoordinator.self, AppCoordinator())

        // …other use cases if going full clean architecture

        // ViewModels
        DI.shared.register(RepositoryViewModel.self, RepositoryViewModel(service: apiService))
        DI.shared.register(FavoritesManager.self, FavoritesManager())
        DI.shared.register(RepositoryDetailViewModel.Factory.self) { url in
            RepositoryDetailViewModel(url: url, service: apiService)
        }

        // Views
        DI.shared.register(RepositoryListView.self,
                           RepositoryListView(viewModel: DI.shared.resolve(),
                                              favoritesManager:  DI.shared.resolve(),
                                              coordinator: DI.shared.resolve()))
        DI.shared.register(FavoriteRepositoriesView.self,
                           FavoriteRepositoriesView(viewModel: DI.shared.resolve(),
                                                    favoritesManager:  DI.shared.resolve(),
                                                    coordinator: DI.shared.resolve()))
        DI.shared.register(RepositoryDetailView.Factory.self) { url, coordinator in
            RepositoryDetailView(url: url, coordinator: coordinator)
        }
    }
}
