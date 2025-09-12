//
//  RepositoryModel.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

struct SearchRepositories: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]

}
