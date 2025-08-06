//
//  FeedModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 03.06.2025.
//

import UIKit
import CoreData

protocol FeedModelProtocol {
    var numberOfRows: Int { get }
    var filteredPosts: [FavoritePost] { get set }
    func check(_ password: String?) -> Bool
    func fetchFavoritePosts() -> [FavoritePost]
    func deleteFavoritePost(objectID: NSManagedObjectID) async
    func fetchPostBy(author: String)
}

final class FeedModel: FeedModelProtocol {
    private let secretWord = "Secret"
    
    func check(_ password: String?) -> Bool {
        guard let password = password else {
            return false 
        }
        return password == secretWord
    }
    
    private let coreDataManager = CoreDataManager.shared
    
    var filteredPosts: [FavoritePost] = []
    

    var numberOfRows: Int {
        coreDataManager.fetchFavoritePosts().count
    }
    
    func fetchFavoritePosts() -> [FavoritePost] {
        coreDataManager.fetchFavoritePosts()
    }
    
    func deleteFavoritePost(objectID: NSManagedObjectID) async {
        await coreDataManager.deleteFavoritePost(objectID: objectID)
    }
    
    func fetchPostBy(author: String) {
        filteredPosts = coreDataManager.fetchPostBy(author: author)
    }
}
