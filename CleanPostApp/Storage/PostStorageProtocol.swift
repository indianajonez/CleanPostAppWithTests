//
//  PostStorageProtocol.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import Foundation

// MARK: - PostStorageProtocol

protocol PostStorageProtocol {
    func loadPosts() -> [Post]
    func save(posts: [Post])
    func loadFavoriteIds() -> [Int]
    func saveFavoriteIds(_ ids: [Int])
}

