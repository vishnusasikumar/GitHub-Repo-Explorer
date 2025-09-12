//
//  StargazerBand.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum StargazerBand: String, CaseIterable {
    case none = "No Stars"
    case low = "1–10 Stars"
    case medium = "11–100 Stars"
    case high = "101–1000 Stars"
    case veryHigh = "1000+ Stars"

    static func from(count: Int?) -> StargazerBand {
        guard let count = count else {
            return .none
        }

        switch count {
            case 0:
                return .none
            case 1...10:
                return .low
            case 11...100:
                return .medium
            case 101...1000:
                return .high
            default:
                return .veryHigh
        }
    }
}
