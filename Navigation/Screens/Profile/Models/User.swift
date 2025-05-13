//
//  User.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import UIKit

final class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(
        login: String,
        fullName: String,
        avatar: UIImage,
        status: String
    ) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

extension User {
    static let currentUser = User(
        login: "develop",
        fullName: "Razumov Pavel",
        avatar: UIImage(named: "user-1")!,
        status: "veni vidi vici"
    )
}
