//
//  FeedModel.swift
//  Navigation
//
//  Created by Razumov Pavel on 03.06.2025.
//

import UIKit

protocol FeedModelProtocol {
    var numberOfRows: Int { get }
    func check(_ password: String?) -> Bool
    func fetchFavoritePosts() -> [FavoritePost]
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
    
    var numberOfRows: Int {
        coreDataManager.fetchFavoritePosts().count
    }
    
    func fetchFavoritePosts() -> [FavoritePost] {
        coreDataManager.fetchFavoritePosts()
    }
}
