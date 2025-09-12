//
//  GroupingOption.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum GroupingOption: String, CaseIterable, Identifiable {
    case language
    case ownerType
    case stargazerBand
    case updatedMonth
    case forkStatus

    var id: String { rawValue }

    var label: String {
        switch self {
            case .language: return "Language"
            case .ownerType: return "Owner Type"
            case .stargazerBand: return "Stargazer Band"
            case .updatedMonth: return "Updated Month"
            case .forkStatus: return "Fork Status"
        }
    }

    var icon: String {
        switch self {
            case .language: return "textformat"
            case .ownerType: return "person.2.fill"
            case .stargazerBand: return "star.lefthalf.fill"
            case .updatedMonth: return "calendar"
            case .forkStatus: return "tuningfork"
        }
    }
}
