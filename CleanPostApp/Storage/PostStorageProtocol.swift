
import Foundation

protocol PostStorageProtocol {
    func loadPosts() -> [Post]
    func save(posts: [Post])
    func loadFavoriteIds() -> [Int]
    func saveFavoriteIds(_ ids: [Int])
}

