//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Razumov Pavel on 04.08.2025.
//

import Foundation
import CoreData
import StorageService

enum AddFavofiteResult {
    case success
    case alreadyExist
    case failure(Error)
}

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
    
    private func isPostAlreadyFavorite(id: UUID) -> Bool {
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        return (try? context.fetch(request).count) ?? 0 > 0
    }
    
    func addFavoritePost(_ post: Post) -> AddFavofiteResult {
        
        if isPostAlreadyFavorite(id: post.id) {
            return .alreadyExist
        }
        
        let favoritePost = FavoritePost(context: context)
        favoritePost.id = post.id
        favoritePost.author = post.author
        favoritePost.desc = post.description
        favoritePost.image = post.image
        favoritePost.likes = Int32(post.likes)
        favoritePost.views = Int32(post.views)
        
        do {
            try context.save()
            return .success
        } catch {
            print("Error saving context: \(error)")
            return .failure(error)
        }
    }
    
    func fetchFavoritePosts() -> [FavoritePost] {
        let request = FavoritePost.fetchRequest()
        let results = (try? context.fetch(request)) ?? []
        return results
    }
}
