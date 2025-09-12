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
                            Text("Idle")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)

                        case .loading:
                            ProgressView("Loading repositories...")

                        case .success:
                            VStack {
                                repoListView
                                paginationControls
                            }

                        case .failure(let error):
                            VStack(spacing: 12) {
                                Text("Error")
                                    .font(.title)
                                Text(error.errorDescription ?? "Unknown error")
                                    .multilineTextAlignment(.center)
                                Button("Retry") {
                                    viewModel.searchQuery = viewModel.searchQuery
                                }
                            }
                            .padding()
                    }
                    Spacer()
                }
            }
            .navigationTitle("GitHub Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Group By", selection: $viewModel.groupingOption) {
                        ForEach(GroupingOption.allCases) { option in
                            Label(option.label, systemImage: option.icon)
                                .tag(option)
                        }
                    }
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
                            repoRow(repo)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    private func repoRow(_ repo: Repository) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(repo.fullName ?? "Unknown Name")
                    .font(.headline)
                if let language = repo.language {
                    Text(language)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                if let stargazersCount = repo.stargazersCount {
                    Text(StargazerBand.from(count: stargazersCount).rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Button(action: {
                favoritesManager.toggleFavorite(repo)
            }) {
                Image(systemName: favoritesManager.isFavorited(repo) ? "star.fill" : "star")
                    .foregroundColor(favoritesManager.isFavorited(repo) ? .yellow : .gray)
            }
            .buttonStyle(BorderlessButtonStyle()) // prevents row selection when tapping star
        }
    }

    private var paginationControls: some View {
        HStack {
            paginationButton(rel: "first")
            paginationButton(rel: "prev")
            paginationButton(rel: "next")
            paginationButton(rel: "last")
        }
    }

    @ViewBuilder
    private func paginationButton(rel: String) -> some View {
        let isEnabled = viewModel.paginationLinks[rel] != nil

        // Map rel to SF Symbol name
        let systemImageName: String = {
            switch rel {
                case "first":
                    return "arrow.backward.to.line"
                case "prev":
                    return "arrow.backward"
                case "next":
                    return "arrow.forward"
                case "last":
                    return "arrow.forward.to.line"
                default:
                    return "questionmark"
            }
        }()

        Button(action: {
            Task {
                await viewModel.loadPage(for: rel)
            }
        }) {
            Image(systemName: systemImageName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .gray)
                .frame(width: 36, height: 36)
                .background(isEnabled ? Color.accentColor : Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
        .padding(.horizontal, 10)
        .disabled(!isEnabled)
    }
}

#Preview {
    RepositoryListView(viewModel: DI.shared.resolve(),
                       favoritesManager: DI.shared.resolve())
}
