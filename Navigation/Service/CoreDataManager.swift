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
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    private func isPostAlreadyFavorite(id: String) -> Bool {
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return (try? context.fetch(request).count) ?? 0 > 0
    }
    
    func addFavoritePost(_ post: Post) async throws -> AddFavofiteResult {
        
        return try await withCheckedThrowingContinuation { continuation in
            backgroundContext.perform {
                if self.isPostAlreadyFavorite(id: post.id) {
                    return continuation.resume(returning: .alreadyExist)
                }
                
                let favoritePost = FavoritePost(context: self.backgroundContext)
                favoritePost.id = post.id
                favoritePost.author = post.author
                favoritePost.desc = post.description
                favoritePost.image = post.image
                favoritePost.likes = Int32(post.likes)
                favoritePost.views = Int32(post.views)
                
                do {
                    try self.backgroundContext.save()
                    continuation.resume(returning: .success)
                } catch {
                    print("Error saving context: \(error)")
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteFavoritePost(objectID: NSManagedObjectID) async {
        do {
            try await backgroundContext.perform {
                let object = self.backgroundContext.object(with: objectID)
                self.backgroundContext.delete(object)
                try self.backgroundContext.save()
            }
        } catch {
            print(error)
        }
    }
    
    func fetchFavoritePosts() -> [FavoritePost] {
        let request = FavoritePost.fetchRequest()
        let results = (try? context.fetch(request)) ?? []
        return results
    }
    
    func fetchPostBy(author: String) -> [FavoritePost] {
        let predicate = NSPredicate(format: "author == %@", author)
        let fetchRequest = NSFetchRequest<FavoritePost>(entityName: "FavoritePost")
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
