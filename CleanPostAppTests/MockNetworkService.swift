//
//  MockNetworkService.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 20.05.2025.
//

import Foundation
import Combine

// MARK: - MockNetworkService

class MockNetworkService: NetworkServiceProtocol {
    
    // MARK: - Test Configuration

    var result: Result<[Post], Error> = .success([])

    // MARK: - NetworkServiceProtocol

    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error> {
        result.publisher.eraseToAnyPublisher()
    }
}

