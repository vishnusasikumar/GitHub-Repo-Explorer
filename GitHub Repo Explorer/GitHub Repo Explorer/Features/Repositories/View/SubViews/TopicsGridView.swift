//
//  TopicsGridView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 13/09/2025.
//

import SwiftUI

struct TopicsGridView: View {
    let topics: [String]

    // 3 columns grid as an example
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(topics, id: \.self) { topic in
                Text(topic)
                    .padding(6)
                    .background(Constants.Colors.topicsBackgroundColor)
                    .foregroundColor(Constants.Colors.topicsColor)
                    .cornerRadius(Constants.Design.cornerRadius)
            }
        }
        .padding()
    }
}

#Preview {
    let repository = RepositoryMock.mockDetails
    TopicsGridView(topics: repository.topics)
}
