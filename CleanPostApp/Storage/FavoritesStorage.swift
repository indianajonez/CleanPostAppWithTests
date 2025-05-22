//
//  FavoritesStorage.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import Foundation

// MARK: - FavoritesStorage

final class FavoritesStorage {
    
    // MARK: - Keys

    private let favoritesKey = "favoriteIds"
    private let customPostsKey = "customPosts"

    // MARK: - Favorites

    func save(favoriteIds: [Int]) {
        UserDefaults.standard.set(favoriteIds, forKey: favoritesKey)
    }

    func loadFavoriteIds() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    // MARK: - Custom Posts

    func saveCustomPosts(_ posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: customPostsKey)
        }
    }

    func loadCustomPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: customPostsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }
}
