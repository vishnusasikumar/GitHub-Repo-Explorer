//
//  ErrorView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let errorDescription: String
    var showRetry: Bool = true
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: Constants.Design.cardSpacing) {
            Text(errorMessage)
                .font(.title)
            Text(errorDescription)
                .multilineTextAlignment(.center)
            if showRetry {
                Button(Constants.Strings.tryAgainButton, action: retryAction)
            }
        }
        .accessibilityIdentifier(Constants.Strings.errorView)
        .padding()
    }
}

#Preview {
    ErrorView(errorMessage: Constants.Strings.errorMessage, errorDescription: Constants.Strings.unknown) { }
}
