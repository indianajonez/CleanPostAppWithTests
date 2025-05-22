//
//  MockPostStorage.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 20.05.2025.
//

import Foundation

// MARK: - MockPostStorage

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


