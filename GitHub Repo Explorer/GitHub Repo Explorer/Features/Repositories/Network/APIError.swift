//
//  APIError.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum APIError: LocalizedError, Identifiable, Equatable {
    // Network related errors
    case networkFailed(error: Error)       // Wrap underlying network error
    case requestFailed(error: Error)       // Another network failure case?
    case requestTimedOut

    // HTTP status errors
    case error204
    case error400
    case error401
    case error404
    case error500
    case unknownStatusCode(Int)             // Unknown HTTP status code

    // Parsing errors
    case decodingFailed(error: Error)

    // API specific
    case rateLimit(message: String)

    // Other errors
    case invalidUrl
    case unknownError
    case other(message: String)

    // MARK: - Identifiable (use description as id)
    var id: String { localizedDescription }

    // MARK: - LocalizedError Description
    var errorDescription: String? {
        switch self {
            case .networkFailed(let error):
                return "Network error: \(error.localizedDescription)"
            case .requestFailed(let error):
                return "Request failed: \(error.localizedDescription)"
            case .requestTimedOut:
                return "Request timed out."
            case .error204:
                return "No content (204)."
            case .error400:
                return "Bad request (400)."
            case .error401:
                return "Unauthorized (401)."
            case .error404:
                return "Not found (404)."
            case .error500:
                return "Internal server error (500)."
            case .unknownStatusCode(let code):
                return "Unexpected error with status code \(code)."
            case .decodingFailed(let error):
                return "Failed to parse data: \(error.localizedDescription)"
            case .rateLimit(let message):
                return message
            case .invalidUrl:
                return "Invalid URL."
            case .unknownError:
                return "Unknown error occurred."
            case .other(let message):
                return message
        }
    }

    // MARK: - Equatable Implementation
    static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
            case (.networkFailed(let e1), .networkFailed(let e2)):
                return e1.localizedDescription == e2.localizedDescription
            case (.requestFailed(let e1), .requestFailed(let e2)):
                return e1.localizedDescription == e2.localizedDescription
            case (.requestTimedOut, .requestTimedOut),
                (.error204, .error204),
                (.error400, .error400),
                (.error401, .error401),
                (.error404, .error404),
                (.error500, .error500),
                (.invalidUrl, .invalidUrl),
                (.unknownError, .unknownError):
                return true
            case (.unknownStatusCode(let c1), .unknownStatusCode(let c2)):
                return c1 == c2
            case (.decodingFailed(let e1), .decodingFailed(let e2)):
                return e1.localizedDescription == e2.localizedDescription
            case (.rateLimit(let m1), .rateLimit(let m2)),
                (.other(let m1), .other(let m2)):
                return m1 == m2
            default:
                return false
        }
    }
}
