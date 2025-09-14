# 📘 GitHub Repository Explorer

A SwiftUI-driven GitHub repository search and detail viewer, with modern SwiftUI navigation, MVVM architecture, deep linking, DI, and unit testing support.

---

## 🚀 Features

- 🔍 **Repository Search** with pagination and debounced input
- 📑 **Repository Details** with full content display
- ⭐️ **Favorites** support with persistent storage
- 📂 **Grouping** repositories by language, owner type, forks, etc.
- 🔗 **Deep Linking** (e.g. `ghre://search/repository/12345`)
- 🧪 **Unit Tests** for ViewModels, Coordinator, and FavoritesManager
- 💉 **Dependency Injection** with custom lightweight DI container

---

## 🧠 Key Concepts & Decisions

### ✅ MVVM Architecture
- `RepositoryViewModel` and `RepositoryDetailViewModel` wrap data-fetching and state.
- Views are still light and reactive to `@Published` properties.

### ✅ Dependency Injection
- Custom `DI` container (`DI.shared`) used for lightweight dependency registration and resolution.
- ViewModels injected through factory closures in order to allow testing and mocking.

### ✅ Coordinator Pattern
- Programmatic navigation and deep linking managed by `AppCoordinator`.
- Published `path` property used with `NavigationStack` to navigate to detail screen.

### ✅ Deep Linking
- Supports URLs like `ghre://search/repository/12345` and `ghre://search/favorites`.
- Refetches `AppCoordinator` automatically to show the correct screen.

### ✅ Async/Await & Combine
- Uses `async/await` for API calls.
- Uses `Combine` to debounce search input and observe changes in grouping.

---

## 🧠 Key Architectural Decisions

### 🔠 Repository Grouping Logic

Repositories are dynamically categorized in the UI by user-controllable attribute (GroupingOption). They include:
- Language – Primary language of the repository.
- Owner Type – Ownership by user or organization.
- Stargazer Band – Bins of popularity (e.g., <100 stars, 100–500, 500+).
- Updated Month – Extracted from repository last updated date.
- Forking Status – Whether the repo is forking-enabled.

This partitioning is computed on the fly in the RepositoryViewModel and employs Dictionary(grouping:by:) to divide the data.

💡 Why? This makes it easier for users to navigate through large result sets along important dimensions.

### 📄 Pagination Strategy

Pagination is done using GitHub's Link headers, which are parsed and stored as a [String: URL] dictionary. The app supports:
- Ordinary pagination (next, previous, first, last) based on relation types.
- Paginated lazy loading user interaction on pagination controls.

Pagination links are reloaded with every API response and remapped to UI controls (e.g., Next and Previous buttons).

💡 Why? The pagination scheme in GitHub is link-based, and this avoids manual page tracking and simplifies state management.

### 🚨 Error Handling & User Feedback

The app uses a custom APIError enum to cover a wide range of error types:
- Network & decoding errors (i.e., no connection, timeouts, JSON decoding)
- HTTP status errors (i.e., 401 Unauthorized, 404 Not Found)
- Custom API-specific errors (i.e., rate limiting)

Each error is mapped to a localized, human-readable description and presented in the UI through a consistent ErrorView component with:
- A title
- A message
- Optional retry support

✅ User feedback is always privileged, and technical errors are never presented directly without interpretation.

---

## 🧪 Testing

- Implemented with `Swift Testing`
- Includes:
  - ViewModel tests (success & failure flows)
  - Behavior tests for Coordinator
  - Tests for `FavoritesManager` persistence

### ✅ Mocking
- `GitHubServiceProtocol` makes it easy to mock API responses.
- `UserDefaults` mock used to decouple `FavoritesManager` tests.

---

## 📌 Constants Management
- Pooled within `Constants.swift`
- Brought under sub-structs (`Strings`, `Colors`, `Design`, etc.)

---

## 🔧 Future Improvements

- 🧑‍🤝‍🧑 Add user profile viewing and repo starring.
- 🔍 Add filter/sorting controls to search results.
- 💡 Migrate DI to a third-party framework like **Resolver** or **Factory** if app scales.

---

## 🏗️ Setup & Run

1. Clone the repo:
  ```bash
  git clone https://github.com/your-username/github-explorer.git
  cd github-explorer
  ```
2. Open in Xcode: 
  ```bash
  open GitHubExplorer.xcodeproj
  ```
3.Build & Run 
  ```bash
  Select a Simulator or your connected device.
  Press Cmd + R or click the ▶️ Run button in Xcode.
  ```
6. Run Tests 
  ```bash
  Cmd + U
  ```
  Or via the Product > Test menu in Xcode.

🧑‍💻 Author

Built by Vishnu Sasikumar
