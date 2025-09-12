//
//  RepositoryListView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @ObservedObject var viewModel: RepositoryViewModel
    @ObservedObject var favoritesManager: FavoritesManager

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery)

                Group {
                    switch viewModel.loadingState {
                        case .idle:
                            Text(Constants.Strings.noRepositoriesTitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .accessibilityIdentifier(Constants.Strings.idleView)

                        case .loading:
                            ActivityIndicator()
                                .frame(width: Constants.Design.loadingViewSize, height: Constants.Design.loadingViewSize)
                                .foregroundColor(.accentColor)
                                .accessibilityIdentifier(Constants.Strings.loadingView)

                        case .success:
                            VStack {
                                repoListView
                                paginationControls
                            }

                        case .failure(let error):
                            ErrorView(
                                errorMessage: Constants.Strings.errorMessage,
                                errorDescription: error.errorDescription ?? Constants.Strings.unknown,
                                retryAction: {
                                    viewModel.searchQuery = viewModel.searchQuery
                                }
                            )
                    }
                    Spacer()
                }
            }
            .navigationTitle(Constants.Strings.repositoriesTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(Constants.Strings.groupByPickerTitle, selection: $viewModel.groupingOption) {
                        ForEach(GroupingOption.allCases) { option in
                            Label(option.label, systemImage: option.icon)
                                .tag(option)
                        }
                    }
                    .accessibilityIdentifier(Constants.Strings.groupByPicker)
                    .pickerStyle(.menu)
                }
            }
        }
    }

    private var repoListView: some View {
        List {
            ForEach(viewModel.groupedRepositories.keys.sorted(), id: \.self) { key in
                if let repos = viewModel.groupedRepositories[key] {
                    Section(header: Text(key)) {
                        ForEach(repos) { repo in
                            RepositoryRowView(repo: repo)
                        }
                    }
                }
            }
        }
        .accessibilityIdentifier(Constants.Strings.repositoriesList)
        .listStyle(InsetGroupedListStyle())
    }

    @ViewBuilder
    private var paginationControls: some View {
        HStack {
            ForEach(Rel.allCases) { option in
                PaginationButton(rel: option)
            }
        }
        .accessibilityIdentifier(Constants.Strings.paginationControls)
    }
}

#Preview {
    RepositoryListView(viewModel: DI.shared.resolve(),
                       favoritesManager: DI.shared.resolve())
}
