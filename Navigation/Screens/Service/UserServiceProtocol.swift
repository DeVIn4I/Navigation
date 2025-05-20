//
//  UserServiceProtocol.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import Foundation

protocol UserService {
    func checkUserWith(login: String) -> User?
}
