//
//  UserServiceProtocol.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import Foundation

protocol UserService {
    var user: User { get }
    func getUser() -> User
}

extension UserService {
    func getUser() -> User { user }
}
