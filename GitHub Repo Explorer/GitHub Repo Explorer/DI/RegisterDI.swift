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
        DI.shared.register(apiService as GitHubServiceProtocol)

        // …other use cases if going full clean architecture

        // ViewModels
        DI.shared.register(RepositoryViewModel(service: apiService))
        DI.shared.register(FavoritesManager())

        // Views
        DI.shared.register(RepositoryListView(viewModel: DI.shared.resolve(), favoritesManager:  DI.shared.resolve()))
        DI.shared.register(FavoriteRepositoriesView(viewModel: DI.shared.resolve(), favoritesManager:  DI.shared.resolve()))
    }
}
