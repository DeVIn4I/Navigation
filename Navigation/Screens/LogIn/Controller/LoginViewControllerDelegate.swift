//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Razumov Pavel on 20.05.2025.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
