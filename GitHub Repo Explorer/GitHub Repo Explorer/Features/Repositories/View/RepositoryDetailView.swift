//
//  RepositoryDetailView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 13/09/2025.
//

import SwiftUI
 
struct RepositoryDetailView: View {
    @StateObject var viewModel: RepositoryDetailViewModel
    @ObservedObject var coordinator: AppCoordinator

    #if DEBUG
    init(viewModel: RepositoryDetailViewModel, coordinator: AppCoordinator) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    #endif

    init(url: URL, coordinator: AppCoordinator) {
        let factory: RepositoryDetailViewModel.Factory = DI.shared.resolve()
        _viewModel = StateObject(wrappedValue: factory(url))
        self.coordinator = coordinator
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ActivityIndicator()
                    .frame(width: Constants.Design.loadingViewSize, height: Constants.Design.loadingViewSize)
                    .foregroundColor(Constants.Colors.primaryColor)
                    .accessibilityIdentifier(Constants.Strings.loadingView)
            } else if let repo = viewModel.repository {
                ScrollView {
                    RepositoryDetailContentView(repository: repo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .frame(maxWidth: .infinity)
            } else if let error = viewModel.errorMessage {
                ErrorView(
                    errorMessage: Constants.Strings.repositoryDetailsErrorMessage,
                    errorDescription: error,
                    retryAction: {
                        Task {
                            await viewModel.load()
                        }
                    }
                )
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.load()
        }
        .onDisappear {
            viewModel.repository = nil
            coordinator.resetNavigation()
        }
    }
}

extension RepositoryDetailView {
    typealias Factory = (URL, AppCoordinator) -> RepositoryDetailView
}

#Preview {
    RepositoryDetailView(
        url: URL(string: "https://api.github.com/repos/krahets/hello-algo")!,
        coordinator: DI.shared.resolve()
    )
}
