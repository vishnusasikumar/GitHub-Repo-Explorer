//
//  GitHubServiceProtocol.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum APIEnvironment {
    static func resolve() -> GitHubServiceProtocol {
        //TODO: - Move to proper APIConfig instead
        #if RELEASE
        return MockGitHubService()
        #else
        return GitHubService()
        #endif
    }
}

protocol GitHubServiceProtocol {
    func search<T: Decodable>(_ type: T.Type, with query: String, page: Int, perPage: Int) async throws -> (T, [String: URL])
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> (T, [String: URL])
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}
