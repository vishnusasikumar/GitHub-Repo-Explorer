//
//  PaginationButton.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct PaginationButton: View {
    let rel: Rel
    @ObservedObject var viewModel: RepositoryViewModel = DI.shared.resolve()

    private var isEnabled: Bool {
        viewModel.paginationLinks[rel.rawValue] != nil
    }

    private var systemImageName: String {
        switch rel {
            case .first: return Constants.Icons.first
            case .prev: return Constants.Icons.prev
            case .next: return Constants.Icons.next
            case .last: return Constants.Icons.last
        }
    }

    var body: some View {
        Button {
            Task {
                await viewModel.loadPage(for: rel.rawValue)
            }
        } label: {
            Image(systemName: systemImageName)
                .font(.title3)
                .foregroundColor(isEnabled ? Constants.Colors.secondaryColor : Constants.Colors.disabledColor)
                .frame(width: Constants.Design.iconSize, height: Constants.Design.iconSize)
                .background(isEnabled ? Constants.Colors.primaryColor : Constants.Colors.buttonDisabledColor)
                .clipShape(Circle())
        }
        .padding(.horizontal, Constants.Design.buttonPadding)
        .disabled(!isEnabled)
    }
}

#Preview {
    PaginationButton(rel: .first)
}
