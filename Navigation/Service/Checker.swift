//
//  Checker.swift
//  Navigation
//
//  Created by Razumov Pavel on 20.05.2025.
//

import UIKit

final class Checker {
    
    static let shared = Checker()
    
    private let login = "admin"
    private let password = "pas"
    
    private init() {}
    
    public func check(login: String, password: String) -> Bool {
        self.login == login && self.password == password
    }
    
    public var getPassword: String {
        password
    }
}
