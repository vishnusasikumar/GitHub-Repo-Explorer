//
//  RepositoryDetailsModel.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 13/09/2025.
//

import Foundation

// MARK: - RepositoryDetailsModel
struct RepositoryDetailsModel: Codable, Identifiable {
    let id: Int
    let fullName: String
    let description: String?
    let isPrivate: Bool
    let stargazersCount: Int
    let language: String?
    let archived: Bool
    let license: License?
    let topics: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case fullName
        case isPrivate = "private"
        case description
        case stargazersCount
        case language
        case archived
        case license
        case topics
    }
}

// MARK: - License
struct License: Codable {
    let key, name: String
    let url: String?

    enum CodingKeys: String, CodingKey {
        case key, name
        case url
    }
}
