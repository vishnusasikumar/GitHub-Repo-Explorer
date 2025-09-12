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
                .environmentObject(viewModel)
                .environmentObject(favoritesManager)
                .tabItem {
                    Label("Repositories", systemImage: "list.bullet")
                }

            // Favorites tab
            FavoriteRepositoriesView(viewModel: viewModel, favoritesManager: favoritesManager)
                .environmentObject(viewModel)
                .environmentObject(favoritesManager)
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
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
