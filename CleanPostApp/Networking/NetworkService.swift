//
//  NetworkService.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import Foundation
import Combine

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error>
}

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"
    private let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - Public Methods

    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "\(baseURL)?_page=\(page)&_limit=20") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
