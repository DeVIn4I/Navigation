//
//  User.swift
//  Navigation
//
//  Created by Razumov Pavel on 13.05.2025.
//

import UIKit

final class User {
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(
        fullName: String,
        avatar: UIImage,
        status: String
    ) {
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}
