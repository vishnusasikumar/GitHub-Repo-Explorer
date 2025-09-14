//
//  GroupByPickerView.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 14/09/2025.
//

import SwiftUI

struct GroupByPickerView: View {
    @Binding var selectedOption: GroupingOption

    var body: some View {
        Picker(Constants.Strings.groupByPickerTitle, selection: $selectedOption) {
            ForEach(GroupingOption.allCases) { option in
                Label(option.label, systemImage: option.icon)
                    .tag(option)
            }
        }
        .accessibilityIdentifier(Constants.Strings.groupByPicker)
        .pickerStyle(.menu)
    }
}

#Preview {
    GroupByPickerView(selectedOption: .constant(.language))
}
