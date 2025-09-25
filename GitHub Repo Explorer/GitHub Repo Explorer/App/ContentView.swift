//
//  ContentView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator: AppCoordinator = DI.shared.resolve()
    @StateObject var viewModel: RepositoryViewModel = DI.shared.resolve()
    @StateObject var favoritesManager: FavoritesManager = DI.shared.resolve()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TabView(selection: $coordinator.selectedTab) {
                RepositoryListView(
                    viewModel: viewModel,
                    favoritesManager: favoritesManager,
                    coordinator: coordinator
                )
                .tabItem {
                    Label(Constants.Strings.repositoriesTabTitle, systemImage: Constants.Icons.repositoriesTab)
                }
                .tag(MainTab.repositories)

                FavoriteRepositoriesView(
                    viewModel: viewModel,
                    favoritesManager: favoritesManager,
                    coordinator: coordinator
                )
                .tabItem {
                    Label(Constants.Strings.favoritesTabTitle, systemImage: Constants.Icons.favoritesTab)
                }
                .tag(MainTab.favorites)
            }
            .navigationDestination(for: Int.self) { repoId in
                if let url = viewModel.repositoryURL(for: repoId) {
                    RepositoryDetailView(url: url, coordinator: coordinator)
                } else {
                    ErrorView(
                        errorMessage: Constants.Strings.repositoryDetailsErrorMessage,
                        errorDescription: Constants.Strings.errorDescription,
                        showRetry: false,
                        retryAction: {}
                    )
                }
            }
            .sheet(item: Binding(
                get: { coordinator.presentedRepositoryId },
                set: { coordinator.presentedRepositoryId = $0 }
            )) { repoId in
                if let url = viewModel.repositoryURL(for: repoId) {
                    RepositoryDetailView(url: url, coordinator: coordinator)
                } else {
                    ErrorView(
                        errorMessage: Constants.Strings.repositoryDetailsErrorMessage,
                        errorDescription: Constants.Strings.errorDescription,
                        showRetry: false,
                        retryAction: {}
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    GroupByPickerView(selectedOption: $viewModel.groupingOption)
                        .disabled(coordinator.selectedTab != .repositories)
                }
            }
            .task {
                await viewModel.loadInitial()
            }
            .navigationTitle(titleForSelectedTab)
            .onChange(of: coordinator.selectedTab) { newTab in
                coordinator.resetNavigation()
                coordinator.dismissModal()
            }
        }
        .environmentObject(coordinator)
        .onOpenURL { url in
            coordinator.handleDeepLink(url: url)
        }
    }

    private var titleForSelectedTab: String {
        switch coordinator.selectedTab {
            case .repositories:
                return Constants.Strings.repositoriesTitle
            case .favorites:
                return Constants.Strings.favouritesTitle
        }
    }
}

#Preview {
    ContentView()
}
