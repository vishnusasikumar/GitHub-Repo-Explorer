//
//  RepositoryRowView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct RepositoryRowView: View {
    let repo: Repository
    @ObservedObject var favoritesManager: FavoritesManager = DI.shared.resolve()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(repo.fullName ?? Constants.Strings.noNameString)
                    .accessibilityIdentifier(Constants.Strings.repositoryNameLabel)
                    .font(.headline)
                Text(repo.owner.login)
                    .accessibilityIdentifier(Constants.Strings.repositoryOwnerLoginLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                favoritesManager.toggleFavorite(repo)
            }) {
                Image(systemName: favoritesManager.isFavorited(repo) ? Constants.Icons.isFavourite : Constants.Icons.favourite)
                    .foregroundColor(favoritesManager.isFavorited(repo) ? Constants.Colors.positiveFavouriteColor : Constants.Colors.negativeFavouriteColor)
            }
            .accessibilityIdentifier(Constants.Strings.favouriteToggle)
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview {
    RepositoryRowView(repo: RepositoryMock.sample1)
}
