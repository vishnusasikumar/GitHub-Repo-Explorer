//
//  MockGitHubService.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

final class MockGitHubService: GitHubServiceProtocol {
    func search<T: Decodable>(_ type: T.Type,
                              with query: String,
                              page: Int = 1,
                              perPage: Int = 10) async throws -> (T, [String: URL]) {
        guard let url = Bundle.main.url(forResource: "RepositoriesMock", withExtension: "json") else {
            throw MockServiceError.missingMockFile
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let decoded = try decoder.decode(T.self, from: data)
            return (decoded, [:])
        } catch {
            throw MockServiceError.decodingFailed(error)
        }
    }

    func fetch<T: Decodable>(_ type: T.Type,
                             from url: URL) async throws -> (T, [String: URL]) {
        guard let url = Bundle.main.url(forResource: "RepositoriesMock", withExtension: "json") else {
            throw MockServiceError.missingMockFile
        }

        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let decoded = try decoder.decode(T.self, from: data)
            return (decoded, [:])
        } catch {
            throw MockServiceError.decodingFailed(error)
        }
    }
}

struct RepositoryMock {

    static let sample1 = Repository(
        id: 887025,
        name: "q",
        fullName: "kriskowal/q",
        owner: Owner(
            login: "kriskowal",
            avatarUrl: "https://avatars.githubusercontent.com/u/60294?v=4",
            type: "User"
        ),
        language: "JavaScript",
        htmlUrl: "https://github.com/kriskowal/q",
        stargazersCount: 15081,
        updatedAt: "2025-09-11T18:39:54Z",
        createdAt: "2019-06-12T08:26:27Z",
        allowForking: true
    )

    static let sample2 = Repository(
        id: 3308920,
        name: "q",
        fullName: "harelba/q",
        owner: Owner(
            login: "harelba",
            avatarUrl: "https://avatars.githubusercontent.com/u/985765?v=4",
            type: "User"
        ),
        language: "Python",
        htmlUrl: "https://github.com/harelba/q",
        stargazersCount: 10319,
        updatedAt: "2025-09-10T05:33:42Z",
        createdAt: "2015-11-28T09:48:17Z",
        allowForking: true
    )

    static let list: [Repository] = [sample1, sample2]
}

enum MockServiceError: Error, LocalizedError {
    case missingMockFile
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
            case .missingMockFile:
                return "Mock JSON file not found in bundle."
            case .decodingFailed(let error):
                return "Failed to decode mock JSON: \(error.localizedDescription)"
        }
    }
}
