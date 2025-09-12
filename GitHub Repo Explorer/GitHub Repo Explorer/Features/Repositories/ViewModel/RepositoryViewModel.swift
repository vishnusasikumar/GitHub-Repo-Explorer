//
//  RepositoryViewModel.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI
import Combine

@MainActor
class RepositoryViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var groupedRepositories: [String: [Repository]] = [:]
    @Published var paginationLinks: [String: URL] = [:]
    @Published var loadingState: LoadingState = .idle
    @Published var groupingOption: GroupingOption = .language

    private let service: GitHubServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let debounceDelay: TimeInterval = 0.5
    private let initialQuery = "Q"

    init(service: GitHubServiceProtocol) {
        self.service = service
        observeSearch()
        observeGroupingChange()
    }

    func loadInitial() async {
        groupedRepositories = [:]
        loadingState = .loading
        await search(query: initialQuery, page: 1)
    }

    func loadPage(for rel: String) async {
        guard let url = paginationLinks[rel] else { return }
        loadingState = .loading
        await search(with: url)
    }

    // MARK: - Private methods

    private func observeSearch() {
        Task {
            for await query in $searchQuery
                .values()                       // Convert @Published into AsyncSequence
                .debounce(for: debounceDelay)  // Debounce input to avoid firing too often
                .removeDuplicates()            // Prevent re-querying the same string
                .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                .filter({ !$0.isEmpty }) {

                await search(query: query, page: 1)
            }
        }
    }

    private func observeGroupingChange() {
        $groupingOption
            .sink { [weak self] _ in
                let allRepos = self?.groupedRepositories.flatMap { $0.value } ?? []
                self?.updateGroupRepositories(allRepos, links: self?.paginationLinks ?? [:])
            }
            .store(in: &cancellables)
    }

    private func search(query: String, page: Int) async {
        do {
            let (result, links): (SearchRepositories, [String: URL]) = try await service.search(SearchRepositories.self,
                                                                                                with: query,
                                                                                                page: page,
                                                                                                perPage: Constants.Ints.perPageValue)
            updateGroupRepositories(result.items, links: links)
        } catch let error {
            self.loadingState = .failure(handleError(error))
        }
    }

    private func search(with url: URL) async {
        do {
            let (result, links): (SearchRepositories, [String: URL]) = try await service.fetch(SearchRepositories.self,
                                                                                               from: url)
            updateGroupRepositories(result.items, links: links)
        } catch {
            if let apiError = error as? APIError {
                self.loadingState = .failure(apiError)
            } else {
                self.loadingState = .failure(.other(message: error.localizedDescription))
            }
        }
    }

    private func updateGroupRepositories(_ repos: [Repository], links: [String : URL]) {
        DispatchQueue.main.async {
            self.groupedRepositories = Dictionary(grouping: repos) { repo in
                switch self.groupingOption {
                    case .language:
                        return repo.language ?? "Unknown"
                    case .ownerType:
                        return repo.ownerType
                    case .stargazerBand:
                        return repo.stargazerBand
                    case .updatedMonth:
                        return repo.updatedMonth
                    case .forkStatus:
                        return repo.forkingStatus
                }
            }
            self.paginationLinks = links
            self.loadingState = .success
        }
    }

    private func handleError(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            switch urlError.code {
                case .notConnectedToInternet:
                    return .other(message: "No internet connection.")
                case .timedOut:
                    return .other(message: "Request timed out.")
                default:
                    return .networkFailed(error: error)
            }
        } else {
            return .other(message: error.localizedDescription)
        }
    }
}
