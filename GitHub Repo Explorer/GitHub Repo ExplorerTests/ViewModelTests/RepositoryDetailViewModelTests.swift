//
//  RepositoryDetailViewModelTests.swift
//  GitHub Repo ExplorerTests
//
//  Created by Admin on 14/09/2025.
//

import Testing
import Foundation
@testable import GitHub_Repo_Explorer

struct RepositoryDetailViewModelTests {

    @Test
    func test_load_success() async {
        let mockService = MockGitHubService()
        mockService.repositoryToReturn = "RepositoryDetailsMock"
        let viewModel = await RepositoryDetailViewModel(
            url: URL(string: "https://api.github.com/repos/test")!,
            service: mockService
        )

        await viewModel.load()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.errorMessage == nil)
        await #expect(viewModel.repository?.id == RepositoryMock.mockDetails.id)
    }

    @Test
    func test_load_failure_apiError() async {
        let mockService = MockGitHubService()
        mockService.errorToThrow = .error404
        mockService.shouldReturnError = true

        let viewModel = await RepositoryDetailViewModel(
            url: URL(string: "https://api.github.com/repos/test")!,
            service: mockService
        )

        await viewModel.load()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.repository == nil)
        await #expect(viewModel.errorMessage?.contains(Constants.Strings.detailsErrorMessage) == true)
        await #expect(viewModel.errorMessage?.contains("404") == true)
    }

    @Test
    func test_load_failure_decoding() async {
        let mockService = MockGitHubService()
        let decodingError = DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Invalid JSON")
        )
        mockService.errorToThrow = .decodingFailed(error: decodingError)
        mockService.shouldReturnError = true

        let viewModel = await RepositoryDetailViewModel(
            url: URL(string: "https://api.github.com/repos/test")!,
            service: mockService
        )

        await viewModel.load()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.repository == nil)
        await #expect(viewModel.errorMessage?.contains(Constants.Strings.detailsErrorMessage) == true)
    }

    @Test
    func test_load_failure_other() async {
        let mockService = MockGitHubService()
        mockService.errorToThrow = .other(message: "Something went wrong")
        mockService.shouldReturnError = true

        let viewModel = await RepositoryDetailViewModel(
            url: URL(string: "https://api.github.com/repos/test")!,
            service: mockService
        )

        await viewModel.load()

        await #expect(viewModel.isLoading == false)
        await #expect(viewModel.repository == nil)
        await #expect(viewModel.errorMessage?.contains("Something went wrong") == true)
    }
}

