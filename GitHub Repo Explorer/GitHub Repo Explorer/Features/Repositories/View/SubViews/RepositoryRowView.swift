//
//  RepositoryRowView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct RepositoryRowView: View {
    let repo: Repository
    @Binding var isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(repo.fullName ?? Constants.Strings.noNameString)
                    .accessibilityIdentifier(Constants.Strings.repositoryNameLabel)
                    .font(.headline)
                Text(Date(rawValue: repo.createdAt)?.getDateString() ?? Constants.Strings.unknown)
                    .accessibilityIdentifier(Constants.Strings.repositoryOwnerLoginLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? Constants.Icons.isFavourite : Constants.Icons.favourite)
                    .foregroundColor(isFavorite ? Constants.Colors.positiveFavouriteColor : Constants.Colors.negativeFavouriteColor)
            }
            .accessibilityIdentifier(Constants.Strings.favouriteToggle)
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview {
    RepositoryRowView(repo: RepositoryMock.sample1, isFavorite: .constant(true)) {}
}
