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
        NavigationStack {
            TabView(selection: $coordinator.selectedTab) {
                RepositoryListView(viewModel: viewModel, favoritesManager: favoritesManager, coordinator: coordinator)
                    .tabItem {
                        Label(Constants.Strings.repositoriesTabTitle, systemImage: Constants.Icons.repositoriesTab)
                    }
                    .tag(AppCoordinator.MainTab.repositories)

                FavoriteRepositoriesView(viewModel: viewModel, favoritesManager: favoritesManager, coordinator: coordinator)
                    .tabItem {
                        Label(Constants.Strings.favoritesTabTitle, systemImage: Constants.Icons.favoritesTab)
                    }
                    .tag(AppCoordinator.MainTab.favorites)
            }
            .task {
                await viewModel.loadInitial()
            }
        }
        .environmentObject(coordinator)
        .onOpenURL { url in
            coordinator.handleDeepLink(url: url)
        }
    }
}

#Preview {
    ContentView()
}
