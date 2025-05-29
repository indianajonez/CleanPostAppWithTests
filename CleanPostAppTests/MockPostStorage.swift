
import Foundation

class MockPostStorage: PostStorageProtocol {
    
    // MARK: - Stored Properties

    var savedPosts: [Post] = []
    var savedFavorites: [Int] = []

    // MARK: - PostStorageProtocol

    func save(posts: [Post]) {
        savedPosts = posts
    }

    func loadPosts() -> [Post] {
        return savedPosts
    }

    func saveFavoriteIds(_ ids: [Int]) {
        savedFavorites = ids
    }

    func loadFavoriteIds() -> [Int] {
        return savedFavorites
    }
}


