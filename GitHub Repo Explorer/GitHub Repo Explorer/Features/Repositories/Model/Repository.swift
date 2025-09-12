//
//  Repository.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

struct Repository: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String?
    let owner: Owner
    let language: String?
    let htmlUrl: String?
    let stargazersCount: Int?
    let updatedAt: String?
    let allowForking: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }

    var ownerType: String {
        owner.type
    }

    var stargazerBand: String {
        StargazerBand.from(count: stargazersCount).rawValue
    }

    var updatedMonth: String {
        guard let updatedAt = updatedAt else { return Constants.Strings.unknown }

        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: updatedAt) else { return Constants.Strings.unknown }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM yyyy"
        return displayFormatter.string(from: date)
    }

    var forkingStatus: String {
        allowForking ? "Allows Forking" : "Forking Not Allowed"
    }
}
