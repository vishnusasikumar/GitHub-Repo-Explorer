//
//  RepositoryDetailViewModel.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 13/09/2025.
//

import SwiftUI

@MainActor
class RepositoryDetailViewModel: ObservableObject {
    @Published var repository: RepositoryDetailsModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: GitHubServiceProtocol
    private let url: URL

    init(url: URL, service: GitHubServiceProtocol) {
        self.url = url
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil

        do {
            let repo: RepositoryDetailsModel = try await service.fetch(RepositoryDetailsModel.self, from: url)
            repository = repo
        } catch {
            errorMessage = "\(Constants.Strings.detailsErrorMessage) \(error.localizedDescription)"
        }

        isLoading = false
    }
}

// Factory type alias for DI
extension RepositoryDetailViewModel {
    typealias Factory = (URL) -> RepositoryDetailViewModel
}
