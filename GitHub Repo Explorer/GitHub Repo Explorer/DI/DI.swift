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

    func register<T>(_ type: T.Type, _ instance: T) {
        let key = "\(T.self)"
        services[key] = instance
    }

    func register<T>(_ type: T.Type, factory: @escaping (URL) -> T) {
        let key = "\(T.self)"
        services[key] = factory
    }

    func register<T>(_ type: T.Type, factory: @escaping (URL, AppCoordinator) -> T) {
        let key = "\(T.self)"
        services[key] = factory
    }

    func resolve<T>() -> T {
        let key = "\(T.self)"
        guard let service = services[key] as? T else {
            fatalError("No registered service for type \(T.self)")
        }
        return service
    }
}
