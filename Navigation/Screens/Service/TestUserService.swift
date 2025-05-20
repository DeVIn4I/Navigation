//
//  TestUserService.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import UIKit

final class TestUserService: UserService {
    private var user: User
    
    init(user: User = User.testUser) {
        self.user = user
    }
    
    func checkUserWith(login: String) -> User? {
      login == user.login ? user : nil
    }
}
