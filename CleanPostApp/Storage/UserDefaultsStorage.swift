
import Foundation

final class UserDefaultsStorage: PostStorageProtocol {
    
    // MARK: - Private properties

    private let postsKey = "cachedPosts"
    private let favoritesKey = "favoriteIds"

    // MARK: - Public methods

    func loadPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: postsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }

    func save(posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: postsKey)
        }
    }

    func loadFavoriteIds() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    func saveFavoriteIds(_ ids: [Int]) {
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }
}

