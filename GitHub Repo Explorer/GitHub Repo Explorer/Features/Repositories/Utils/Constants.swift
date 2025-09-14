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
        static let cardSpacing: CGFloat = 16
        static let stargazerBandSpacing: CGFloat = 4
        static let iconPadding: CGFloat = 8
        static let searchFieldPadding: CGFloat = 8
        static let searchFieldHorizontalPadding: CGFloat = 24
        static let topicsPadding: CGFloat = 6
        static let buttonPadding: CGFloat = 10

        // Corner Radius
        static let cornerRadius: CGFloat = 8

        // Sizes
        static let trimMinScale: CGFloat = 0.75
        static let trimMaxScale: CGFloat = 1.0
        static let lineWidth: CGFloat = 16
        static let buttonIconScale: CGFloat = 0.3
        static let iconSize: CGFloat = 36
        static let loadingViewSize: CGFloat = 100

        // Line Width
        static let borderLineWidth: CGFloat = 1
    }

    // MARK: - Strings
    struct Strings {
        // Navigation
        static let repositoriesTabTitle = String(localized: "Repositories")
        static let favoritesTabTitle = String(localized: "Favorites")
        static let repositoriesTitle = String(localized: "GitHub Search")
        static let favouritesTitle = String(localized: "Favorites")

        // Search
        static let placeHolderSearch = String(localized: "Search repositories...")
        static let cancelSearch = String(localized: "Cancel")

        // Error State
        static let errorMessage = String(localized: "Failed to load Repositories")
        static let errorDescription = String(localized: "Something went wrong, please try again later")
        static let repositoryDetailsErrorMessage = String(localized: "Failed to load details url")
        static let tryAgainButton = String(localized: "Try Again")
        static let unknown = String(localized: "Unknown")

        // Empty State
        static let noRepositoriesTitle = String(localized: "No Repositories Found")
        static let noRepositoriesMessage = String(localized: "Try adjusting your date filter to see more results")
        static let noNameString = String(localized: "Unknown Name")
        static let noFavouritesTitle = String(localized: "No favorites yet!")

        static let groupByPickerTitle = String(localized: "Group By")
        static let language = String(localized: "Language")
        static let ownerType = String(localized: "Owner Type")
        static let stargazerBand = String(localized: "Stargazer Band")
        static let updatedMonth = String(localized: "Updated Month")
        static let forkStatus = String(localized: "Fork Status")

        // Details
        static let archived = String(localized: "Archived")
        static let topicsTitle = String(localized: "Topics:")
        static let privateRepository = String(localized: "Private Repository")
        static let publicRepository = String(localized: "Public Repository")
        static let detailsErrorMessage = String(localized: "Failed to load repository details: ")
        static let closeButton = String(localized: "Close")

        // Accessibility
        static let repositoryNameLabel = "RepositoryNameLabel"
        static let repositoryOwnerLoginLabel = "RepositoryOwnerLoginLabel"
        static let favouriteToggle = "FavouriteToggle"
        static let repositoriesList = "RepositoriesList"
        static let favouritesList = "FavouritesList"
        static let idleView = "IdleView"
        static let loadingView = "LoadingIndicator"
        static let paginationControls = "PaginationControls"
        static let groupByPicker = "GroupByPicker"
        static let errorView = "ErrorView"
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
        static let repositoriesTab = "list.bullet"
        static let favoritesTab = "star.fill"
        static let isFavourite = "star.fill"
        static let favourite = "star"

        static let first = "arrow.backward.to.line"
        static let prev = "arrow.backward"
        static let next = "arrow.forward"
        static let last = "arrow.forward.to.line"
        static let unknown = "questionmark"

        static let language = "textformat"
        static let ownerType = "person.2.fill"
        static let stargazerBand = "star.lefthalf.fill"
        static let updatedMonth = "calendar"
        static let forkStatus = "tuningfork"

        static let searchIcon = "magnifyingglass"
        static let clearSearchIcon = "xmark.circle.fill"
        static let licenseIcon = "doc.plaintext"
    }

    // MARK: - Colors
    struct Colors {
        static let primaryColor = Color.accentColor
        static let secondaryColor = Color.white
        static let disabledColor = Color.gray

        static let negativeFavouriteColor = Color.gray
        static let positiveFavouriteColor = Color.yellow

        static let searchTextColor = Color(.systemGray6)

        static let privateColor = Color.red
        static let publicColor = Color.green
        static let stargazerBandColor = Color.yellow
        static let archivedColor = Color.gray
        static let topicsBackgroundColor = Color.blue.opacity(0.2)
        static let topicsColor = Color.blue

        static let errorColor = Color.red
        static let buttonDisabledColor = disabledColor.opacity(Design.buttonIconScale)
    }
}

extension String {
    static var empty: String = ""
}
