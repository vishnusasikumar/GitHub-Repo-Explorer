//
//  Rel.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

enum Rel: String, CaseIterable, Identifiable {
    case first
    case prev
    case next
    case last

    var id: String { rawValue }
}
