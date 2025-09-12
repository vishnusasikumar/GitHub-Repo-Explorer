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
            case .language:
                return Constants.Strings.language
            case .ownerType:
                return Constants.Strings.ownerType
            case .stargazerBand:
                return Constants.Strings.stargazerBand
            case .updatedMonth:
                return Constants.Strings.updatedMonth
            case .forkStatus:
                return Constants.Strings.forkStatus
        }
    }

    var icon: String {
        switch self {
            case .language:
                return Constants.Icons.language
            case .ownerType:
                return Constants.Icons.ownerType
            case .stargazerBand:
                return Constants.Icons.stargazerBand
            case .updatedMonth:
                return Constants.Icons.updatedMonth
            case .forkStatus:
                return Constants.Icons.forkStatus
        }
    }
}
