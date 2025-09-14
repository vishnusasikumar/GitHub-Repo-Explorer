//
//  RepositoryDetailContentView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 13/09/2025.
//

import SwiftUI

struct RepositoryDetailContentView: View {
    let repository: RepositoryDetailsModel

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Design.cardSpacing) {
            // Name
            Text(repository.fullName)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            // Description
            if let description = repository.description {
                Text(description)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Private or public
            Text(repository.isPrivate ? Constants.Strings.privateRepository : Constants.Strings.publicRepository)
                .font(.subheadline)
                .foregroundColor(repository.isPrivate ? Constants.Colors.privateColor : Constants.Colors.publicColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Stargazers count
            HStack(spacing: Constants.Design.stargazerBandSpacing) {
                Image(systemName: Constants.Icons.stargazerBand)
                    .foregroundColor(Constants.Colors.stargazerBandColor)
                Text("\(repository.stargazersCount)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Language
            if let language = repository.language {
                HStack {
                    Image(systemName: Constants.Icons.language)
                    Text(language)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Archived status
            if repository.archived {
                Text(Constants.Strings.archived)
                    .foregroundColor(Constants.Colors.archivedColor)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // License
            if let licenseName = repository.license?.name {
                HStack {
                    Image(systemName: Constants.Icons.licenseIcon)
                    Text(licenseName)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Topics
            if !repository.topics.isEmpty {
                VStack(alignment: .leading) {
                    Text(Constants.Strings.topicsTitle)
                        .font(.headline)
                    WrapView(items: repository.topics) { topic in
                        Text(topic)
                            .padding(Constants.Design.topicsPadding)
                            .background(Constants.Colors.topicsBackgroundColor)
                            .foregroundColor(Constants.Colors.topicsColor)
                            .cornerRadius(Constants.Design.cornerRadius)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}


#Preview {
    RepositoryDetailContentView(repository: RepositoryMock.mockDetails)
}
