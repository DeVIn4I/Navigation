//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 05.06.2025.
//

import Foundation
import StorageService

final class ProfileViewModel {
    
    private(set) var posts: [Post]
    private(set) var user: User?
    
    var numberOfPosts: Int {
        posts.count
    }
    
    var numberOfSection: Int { 2 }
    
    init(user: User?) {
        self.user = user
        self.posts = Post.makePosts()
    }
}
