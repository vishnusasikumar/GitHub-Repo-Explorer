//
//  LoadingState.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failure(APIError)

    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.success, .success):
                return true
            case (.failure(let e1), .failure(let e2)):
                return e1 == e2
            default:
                return false
        }
    }
}
