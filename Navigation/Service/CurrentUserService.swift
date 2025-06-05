//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import UIKit

final class CurrentUserService: UserService {
    
    let user: User = User(
        fullName: "Release Name",
        avatar: UIImage(named: "user-1")!,
        status: "Release user status"
    )
}
