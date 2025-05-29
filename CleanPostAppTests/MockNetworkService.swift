
import Foundation

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

