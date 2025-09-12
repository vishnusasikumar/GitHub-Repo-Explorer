//
//  DI.swift
//  GitHub Repo Explorer
//
//  Created by Admin on 12/09/2025.
//

import Foundation

final class DI {
    static let shared = DI()
    private var services: [String: Any] = [:]
    private init() {}

    func register<T>(_ service: T) {
        let key = "\(T.self)"
        services[key] = service
    }

    func resolve<T>() -> T {
        let key = "\(T.self)"
        guard let service = services[key] as? T else {
            fatalError("No registered service for type \(T.self)")
        }
        return service
    }
}
