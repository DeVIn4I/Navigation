//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import Foundation

protocol UserService {
    func currentUserWith(login: String) -> User?
}

final class CurrentUserService: UserService {
    
    private var user: User
    
    init(user: User = User.currentUser) {
        self.user = user
    }
    
    func currentUserWith(login: String) -> User? {
      login == user.login ? user : nil
    }
}
