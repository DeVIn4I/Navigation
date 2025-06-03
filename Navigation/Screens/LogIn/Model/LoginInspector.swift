//
//  LoginInspector.swift
//  Navigation
//
//  Created by Razumov Pavel on 20.05.2025.
//

import Foundation

final class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        Checker.shared.check(login: login, password: password)
    }
}
