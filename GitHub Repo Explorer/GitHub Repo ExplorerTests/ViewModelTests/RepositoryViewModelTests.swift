//
//  RepositoryViewModelTests.swift
//  GitHub Repo ExplorerTests
//
//  Created by Admin on 12/09/2025.
//

import Testing
@testable import GitHub_Repo_Explorer
import Foundation

@MainActor
struct RepositoryViewModelTests {

    var viewModel: RepositoryViewModel!
    var mockService: MockGitHubService!

    init() {
        mockService = MockGitHubService()
        viewModel = RepositoryViewModel(service: mockService)
    }

    @Test func testLoadingStateAndErrorHandling() async throws {
        let errors: [APIError] = [
            .networkFailed(error: URLError(.notConnectedToInternet)),
            .requestFailed(error: URLError(.badServerResponse)),
            .requestTimedOut,
            .error204,
            .error400,
            .error401,
            .error404,
            .error500,
            .unknownStatusCode(999),
            .decodingFailed(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Decoding error"])),
            .rateLimit(message: "Rate limit exceeded."),
            .invalidUrl,
            .unknownError,
            .other(message: "Custom error message")
        ]

        for error in errors {
            mockService.errorToThrow = error
            mockService.shouldReturnError = true

            await viewModel.loadInitial()

            #expect(viewModel.loadingState == .failure(error), "Expected loadingState to be failure for error: \(error)")
            #expect(viewModel.groupedRepositories.isEmpty, "Error message should not be nil for error: \(error)")

            // Reset error for next iteration
            mockService.errorToThrow = nil
            viewModel.loadingState = .idle
        }
    }

    @Test func test_setup() async throws {
        #expect(viewModel.loadingState == .idle)
        #expect(viewModel.groupedRepositories.isEmpty)
        #expect(viewModel.paginationLinks.isEmpty)
    }

    @Test func test_loadInitial_success() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()

        #expect(viewModel.loadingState == .success)
        #expect(viewModel.groupedRepositories.count == 6) // 6 groups based on the Mock data
        #expect(!viewModel.paginationLinks.isEmpty)
    }

    @Test func test_loadPage_success() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()
        await viewModel.loadPage(for: .next)

        #expect(viewModel.loadingState == .success)
        #expect(!viewModel.groupedRepositories.isEmpty)
    }

    @Test func test_loadPage_fails() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"
        await viewModel.loadInitial()

        mockService.shouldReturnError = true
        mockService.errorToThrow = .invalidUrl

        await viewModel.loadPage(for: .next)

        #expect(viewModel.loadingState == .failure(.invalidUrl))
        #expect(viewModel.groupedRepositories.count == 6)

        // Reset error
        mockService.errorToThrow = nil
        viewModel.loadingState = .idle
    }

    @Test func test_loadPage_invalid() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadPage(for: .prev)

        #expect(viewModel.loadingState == .idle)
        #expect(viewModel.groupedRepositories.count == 0)
    }

    @Test func test_repositoryURL_found() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()
        let url = viewModel.repositoryURL(for: RepositoryMock.sample1.id)

        #expect(viewModel.loadingState == .success)
        #expect(url?.absoluteString == RepositoryMock.sample1.url)
    }

    @Test func test_repositoryURL_notFound() async throws {
        mockService.errorToThrow = .error204
        mockService.shouldReturnError = true

        await viewModel.loadInitial()
        let url = viewModel.repositoryURL(for: RepositoryMock.sample1.id)

        #expect(viewModel.loadingState == .failure(.error204))
        #expect(url == nil)

        // Reset error
        mockService.errorToThrow = nil
        viewModel.loadingState = .idle
    }

    @Test func test_repositoryURL_invalidID() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()
        let url = viewModel.repositoryURL(for: 999)

        #expect(viewModel.loadingState == .success)
        #expect(url == nil)
    }

    @Test func test_repositoryURL_invalidURL() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()
        let url = viewModel.repositoryURL(for: 3308920)

        #expect(viewModel.loadingState == .success)
        #expect(url == nil)
    }

    @Test
    func test_updateGroupRepositories_empty() async throws {
        mockService.repositoryToReturn = "RepositoriesMock"

        await viewModel.loadInitial()
        viewModel.updateGroupRepositories([], links: [:])

        #expect(viewModel.groupedRepositories.isEmpty)
        #expect(viewModel.loadingState == .idle)
    }

    @Test
    func test_loadInitial_withAPIError() async throws {
        mockService.errorToThrow = .error404
        mockService.shouldReturnError = true

        await viewModel.loadInitial()

        #expect(viewModel.loadingState == .failure(.error404))
    }
}
