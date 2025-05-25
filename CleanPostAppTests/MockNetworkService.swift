//
//  MockNetworkService.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 20.05.2025.
//

import Foundation

// MARK: - MockNetworkService

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<[Post], Error> = .success([])

    func fetchPosts(page: Int) async throws -> [Post] {
        switch result {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}

