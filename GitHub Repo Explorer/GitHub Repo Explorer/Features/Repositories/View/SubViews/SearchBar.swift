//
//  SearchBar.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField(Constants.Strings.placeHolderSearch, text: $text)
                .padding(Constants.Design.searchFieldPadding)
                .padding(.horizontal, Constants.Design.searchFieldHorizontalPadding)
                .background(Constants.Colors.searchTextColor)
                .cornerRadius(Constants.Design.cornerRadius)
                .overlay(
                    HStack {
                        Image(systemName: Constants.Icons.searchIcon)
                            .foregroundColor(Constants.Colors.negativeFavouriteColor)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, Constants.Design.iconPadding)

                        if isEditing && !text.isEmpty {
                            Button(action: {
                                text = .empty
                            }) {
                                Image(systemName: Constants.Icons.clearSearchIcon)
                                    .foregroundColor(Constants.Colors.negativeFavouriteColor)
                                    .padding(.trailing, Constants.Design.iconPadding)
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(Constants.Strings.cancelSearch) {
                    self.isEditing = false
                    self.text = .empty
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .transition(.move(edge: .trailing))
                .animation(.default, value: isEditing)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
