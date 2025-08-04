//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Razumov Pavel on 04.08.2025.
//

import Foundation
import CoreData
import StorageService

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritePostModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func addFavoritePost(_ post: Post) {
        let favoritePost = FavoritePost(context: context)
        favoritePost.author = post.author
        favoritePost.desc = post.description
        favoritePost.image = post.image
        favoritePost.likes = Int32(post.likes)
        favoritePost.views = Int32(post.views)
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func fetchFavoritePosts() -> [FavoritePost] {
        let request = FavoritePost.fetchRequest()
        let results = (try? context.fetch(request)) ?? []
        return results
    }
}
