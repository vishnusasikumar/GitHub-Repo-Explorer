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
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isEnabled ? .white : .gray)
                .frame(width: 36, height: 36)
                .background(isEnabled ? Color.accentColor : Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
        .padding(.horizontal, 10)
        .disabled(!isEnabled)
    }
}

#Preview {
    PaginationButton(rel: .first)
}
