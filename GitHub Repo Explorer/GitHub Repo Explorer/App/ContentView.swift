//
//  ContentView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: RepositoryViewModel = DI.shared.resolve()
    @StateObject var favoritesManager: FavoritesManager = DI.shared.resolve()

    var body: some View {
        TabView {
            // All repositories tab
            RepositoryListView(viewModel: viewModel, favoritesManager: favoritesManager)
                .tabItem {
                    Label(Constants.Strings.repositoriesTabTitle, systemImage: Constants.Icons.repositoriesTab)
                }

            // Favorites tab
            FavoriteRepositoriesView(viewModel: viewModel, favoritesManager: favoritesManager)
                .tabItem {
                    Label(Constants.Strings.favoritesTabTitle, systemImage: Constants.Icons.favoritesTab)
                }
        }
        .task {
            await viewModel.loadInitial()
        }
    }
}

#Preview {
    ContentView()
}
