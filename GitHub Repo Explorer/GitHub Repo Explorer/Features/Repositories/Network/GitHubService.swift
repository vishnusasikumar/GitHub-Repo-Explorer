//
//  GitHubService.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

struct GitHubRequestBuilder {
    static func buildSearchRepositoriesRequest(
        query: String,
        page: Int,
        perPage: Int
    ) throws -> URLRequest {
        var components = URLComponents(string: Constants.GitHubAPIConfig.baseURL)
        components?.path = Constants.GitHubAPIConfig.searchRepositoriesPath
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = components?.url else {
            throw APIError.invalidUrl
        }

        var request = URLRequest(url: url)
        Constants.GitHubAPIConfig.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}


final class GitHubService: GitHubServiceProtocol {
    func search<T: Decodable>(_ type: T.Type,
                              with query: String,
                              page: Int = 1,
                              perPage: Int) async throws -> (T, [String: URL]) {

        let request = try GitHubRequestBuilder.buildSearchRepositoriesRequest(
            query: query,
            page: page,
            perPage: perPage
        )
        return try await performRequest(type, with: request)
    }

    func fetch<T: Decodable>(_ type: T.Type,
                             from url: URL) async throws -> (T, [String: URL]) {
        var request = URLRequest(url: url)
        Constants.GitHubAPIConfig.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return try await performRequest(type, with: request)
    }

    func fetch<T: Decodable>(_ type: T.Type,
                             from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        Constants.GitHubAPIConfig.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        let (result, _) = try await performRequest(type, with: request)

        return result
    }

    // MARK: - Private helper to unify request, error handling, and decoding
    private func performRequest<T: Decodable>(_ type: T.Type, with request: URLRequest) async throws -> (T, [String: URL]) {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.other(message: "Invalid response from server.")
        }

        // Status code handling
        switch httpResponse.statusCode {
            case 200...299:
                break // success
            case 403:
                throw rateLimitResetMessage(from: httpResponse)
            default:
                throw APIError.unknownStatusCode(httpResponse.statusCode)
        }

        let links = GitHubService.parseLinkHeader(httpResponse.value(forHTTPHeaderField: "Link"))

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(type, from: data)
            return (result, links)
        } catch {
            throw APIError.decodingFailed(error: error)
        }
    }

    /// Parse the rate limit reset time from response headers and format a user-friendly message
    private func rateLimitResetMessage(from response: HTTPURLResponse) -> APIError {
        if
            let resetString = response.value(forHTTPHeaderField: "X-RateLimit-Reset"),
            let resetTimeInterval = TimeInterval(resetString)
        {
        let resetDate = Date(timeIntervalSince1970: resetTimeInterval)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeTime = formatter.localizedString(for: resetDate, relativeTo: Date())
        return .rateLimit(message: "API rate limit exceeded. Please try again \(relativeTime).")
        } else {
            return .rateLimit(message: "API rate limit exceeded. Please try again later.")
        }
    }

    // MARK: - Parse Link Header
    static func parseLinkHeader(_ linkHeader: String?) -> [String: URL] {
        guard let header = linkHeader else { return [:] }

        var links: [String: URL] = [:]

        let parts = header.components(separatedBy: ",")
        for part in parts {
            let sections = part.components(separatedBy: ";")
            guard sections.count == 2 else { continue }

            let urlPart = sections[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            let relPart = sections[1].trimmingCharacters(in: .whitespaces)

            let relValue = relPart
                .replacingOccurrences(of: #"rel=""#, with: "")
                .replacingOccurrences(of: "\"", with: "")

            if let url = URL(string: urlPart) {
                links[relValue] = url
            }
        }

        return links
    }
}
