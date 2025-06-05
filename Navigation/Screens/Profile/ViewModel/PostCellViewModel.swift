//
//  PostCellViewModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 05.06.2025.
//

import Foundation
import StorageService

final class PostCellViewModel {
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
    
    init(post: Post) {
        self.author = post.author
        self.description = post.description
        self.image = post.image
        self.likes = post.likes
        self.views = post.views
    }
}
