//
//  CoreDataStorage.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import Foundation
import CoreData

// MARK: - CoreDataStorage

final class CoreDataStorage: PostStorageProtocol {
    
    // MARK: - Properties

    private let context = CoreDataManager.shared.context

    // MARK: - PostStorageProtocol

    func loadPosts() -> [Post] {
        let request: NSFetchRequest<CDPost> = CDPost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            return try context.fetch(request).map { $0.toPost() }
        } catch {
            print("Ошибка загрузки из CoreData: \(error)")
            return []
        }
    }

    func save(posts: [Post]) {
        clearAllPosts()

        for post in posts {
            let entity = CDPost(context: context)
            entity.id = Int64(post.id)
            entity.userId = Int64(post.userId)
            entity.title = post.title
            entity.body = post.body
            entity.isFavorite = post.isFavorite
        }

        try? context.save()
    }

    func loadFavoriteIds() -> [Int] {
        let request: NSFetchRequest<CDPost> = CDPost.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")

        if let favorites = try? context.fetch(request) {
            return favorites.map { Int($0.id) }
        }
        return []
    }

    func saveFavoriteIds(_ ids: [Int]) {
        let request: NSFetchRequest<CDPost> = CDPost.fetchRequest()

        if let posts = try? context.fetch(request) {
            for post in posts {
                post.isFavorite = ids.contains(Int(post.id))
            }
            try? context.save()
        }
    }

    // MARK: - Helpers

    private func clearAllPosts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDPost.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
    }
}
