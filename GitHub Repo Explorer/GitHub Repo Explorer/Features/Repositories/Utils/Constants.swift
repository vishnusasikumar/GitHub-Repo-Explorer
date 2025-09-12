//
//  Constants.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation
import SwiftUI

struct Constants {

    // MARK: - Design System
    struct Design {
        // Padding and Spacing
        static let sectionSpacing: CGFloat = 16
        static let cardSpacing: CGFloat = 16
        static let textSpacing: CGFloat = 4
        static let cardPadding: CGFloat = 20
        static let iconSpacing: CGFloat = 16
        static let datePickerPadding: CGFloat = 16
        static let verticalSpacing: CGFloat = 20

        // Corner Radius
        static let cardCornerRadius: CGFloat = 16
        static let datePickerCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 8

        // Shadows
        static let shadowRadius: CGFloat = 12
        static let shadowOpacity: Double = 0.08
        static let shadowOffset = CGSize(width: 0, height: 4)

        // Opacity
        static let backgroundOpacity: Double = 0.1
        static let borderOpacity: Double = 0.2
        static let strokeOpacity: Double = 0.3
        static let lightShadowRadius: CGFloat = 4
        static let lightShadowOpacity: Double = 0.05
        static let lightShadowOffset = CGSize(width: 0, height: 2)

        // Sizes
        static let progressScale: CGFloat = 1.2
        static let iconSize: CGFloat = 50
        static let minContentHeight: CGFloat = 200

        // Line Width
        static let borderLineWidth: CGFloat = 1
    }

    // MARK: - Strings
    struct Strings {
        // Navigation
        static let navigationTitle = String(localized: "Transactions")
        static let favouritesTitle = String(localized: "Favorites")

        // Loading State
        static let loadingMessage = String(localized: "Loading Transactions")

        // Error State
        static let errorMessage = String(localized: "Failed to load Transactions")
        static let tryAgainButton = String(localized: "Try Again")
        static let unknown = String(localized: "Unknown")

        // Empty State
        static let noTransactionsTitle = String(localized: "No Transactions Found")
        static let noTransactionsMessage = String(localized: "Try adjusting your date filter to see more results")
        static let noNameString = String(localized: "Unknown Name")
        static let noFavouritesTitle = String(localized: "No favorites yet!")

        // Accessibility
        static let repositoryNameLabel = "RepositoryNameLabel"
        static let repositoryOwnerLoginLabel = "RepositoryOwnerLoginLabel"
        static let favouriteToggle = "FavouriteToggle"
        static let startDatePicker = "StartDatePicker"
        static let endDatePicker = "EndDatePicker"
        static let transactionsList = "TransactionsList"
        static let favouritesList = "FavouritesList"
    }

    // MARK: - Ints
    struct Ints {
        // Page Value
        static let perPageValue = 10
    }

    // MARK: - Network
    struct Network {
        static let simulatedDelayNanoseconds: UInt64 = 1 * 1_000_000_000
        static let mockDelayNanoseconds: UInt64 =  10 * 200_000_000
    }

    // TODO: - Make GitHubAPIConfig a protocol to support different environments
    struct GitHubAPIConfig {
        static let baseURL = "https://api.github.com"
        static let searchRepositoriesPath = "/search/repositories"
        static let defaultHeaders: [String: String] = [
            "Accept": "application/vnd.github+json"
        ]
    }

    // MARK: - Date
    struct DateFormat {
        static let apiDateFormat = "yyyy-MM-dd"
    }

    // MARK: - Icons
    struct Icons {
        static let isFavourite = "star.fill"
        static let favourite = "star"
        static let expenseArrow = "arrow.down.circle.fill"
        static let positiveBalance = "plus.circle.fill"
        static let negativeBalance = "minus.circle.fill"

        static let filter = "line.3.horizontal.decrease.circle.fill"
        static let calendar = "calendar"
        static let transactionList = "list.bullet.rectangle"

        static let errorWarning = "exclamationmark.triangle.fill"
        static let emptyTray = "tray"
        static let refresh = "arrow.clockwise"
    }

    // MARK: - Currency
    struct Currency {
        static let defaultCode = "NZD"
    }

    struct Colors {
        static let negativeFavouriteColor = Color.gray
        static let positiveFavouriteColor = Color.yellow
    }
}
