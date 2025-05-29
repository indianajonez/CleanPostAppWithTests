
import Foundation

final class FavoritesStorage {
    
    // MARK: - Private properties

    private let favoritesKey = "favoriteIds"
    private let customPostsKey = "customPosts"

    // MARK: - Private methods

    private func save(favoriteIds: [Int]) {
        UserDefaults.standard.set(favoriteIds, forKey: favoritesKey)
    }

    private func loadFavoriteIds() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    private func saveCustomPosts(_ posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: customPostsKey)
        }
    }

    private func loadCustomPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: customPostsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }
}
