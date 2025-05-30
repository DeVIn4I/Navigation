//
//  TestUserService.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import UIKit

final class TestUserService: UserService {
    
    let user: User = User(
        fullName: "Razumov Pavel",
        avatar: UIImage(named: "user-1")!,
        status: "veni vidi vici"
    )
}
