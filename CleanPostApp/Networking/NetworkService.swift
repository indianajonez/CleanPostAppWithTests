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

// MARK: - APIError

enum APIError: LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingFailed
    case networkError(URLError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный URL."
        case .serverError(let code):
            return "Ошибка сервера: код \(code)."
        case .decodingFailed:
            return "Ошибка обработки данных."
        case .networkError(let urlError):
            return urlError.localizedDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}


final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Config
    
    private enum APIConfig {
        static let baseURL = "https://jsonplaceholder.typicode.com/posts"
        static let pageLimit = 20
    }
    
    // MARK: - Properties

    private let urlSession: URLSession
    
    // MARK: - Init

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Public methods

    func fetchPosts(page: Int) -> AnyPublisher<[Post], Error> {
        guard let url = URL(string: "\(APIConfig.baseURL)?_page=\(page)&_limit=\(APIConfig.pageLimit)") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw APIError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
