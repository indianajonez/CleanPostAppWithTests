
import Foundation

    // MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func fetchPosts(page: Int) async throws -> [Post]
}

    // MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
    
    //MARK: - Private enum

    private enum APIConfig {
        static let baseURL = "https://jsonplaceholder.typicode.com/posts"
        static let pageLimit = 20
    }
    
    //MARK: - Public methods

    func fetchPosts(page: Int) async throws -> [Post] {
        guard var components = URLComponents(string: APIConfig.baseURL) else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "_page", value: "\(page)"),
            URLQueryItem(name: "_limit", value: "\(APIConfig.pageLimit)")
        ]
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.serverError((response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            return try JSONDecoder().decode([Post].self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decodingFailed
        } catch {
            throw APIError.unknown(error)
        }
    }
}
