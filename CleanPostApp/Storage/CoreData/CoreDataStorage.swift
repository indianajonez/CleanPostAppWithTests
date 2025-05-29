
import Foundation
import CoreData

final class CoreDataStorage: PostStorageProtocol {
    
    // MARK: - Private properties

    private let context = CoreDataManager.shared.context

    // MARK: - Public methods

    func loadPosts() -> [Post] {
        let request: NSFetchRequest<CDPost> = CDPost.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            return try context.fetch(request).map { $0.toPost() }
        } catch {
            #if DEBUG
            print("❌ Ошибка загрузки постов из CoreData: \(error.localizedDescription)")
            #endif
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

        CoreDataManager.shared.saveContext()
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
            CoreDataManager.shared.saveContext()
        }
    }

    // MARK: - Private methods

    private func clearAllPosts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDPost.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
        } catch {
            assertionFailure("❌ Ошибка при удалении всех постов: \(error.localizedDescription)")
        }
    }
}
