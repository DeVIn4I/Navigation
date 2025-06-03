//
//  LoginFactory.swift
//  Navigation
//
//  Created by Razumov Pavel on 20.05.2025.
//

import Foundation

struct LoginFactory: LoginFactoryProtocol {
    func makeLoginInspector() -> LoginInspector {
        .init()
    }
}
