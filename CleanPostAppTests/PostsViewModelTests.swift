
import XCTest
@testable import CleanPostApp

final class PostsViewModelTests: XCTestCase {
    
    // MARK: - Properties

    var viewModel: PostsViewModel!
    var storage: MockPostStorage!
    var network: MockNetworkService!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        storage = MockPostStorage()
        network = MockNetworkService()
        viewModel = PostsViewModel(storage: storage, networkService: network) 
    }

    // MARK: - Tests

    func testAddPost() {
        viewModel.addPost(title: "Test", body: "Body")
        XCTAssertEqual(viewModel.posts.count, 1)
        XCTAssertEqual(viewModel.posts[0].title, "Test")
    }

    func testToggleFavorite() {
        let post = Post(id: 1, userId: 0, title: "Test", body: "Body", isFavorite: false)
        viewModel.posts = [post]
        viewModel.toggleFavorite(for: post)
        XCTAssertTrue(viewModel.posts[0].isFavorite)
    }

    func testDeletePost() {
        let post = Post(id: 1, userId: 0, title: "Test", body: "Body")
        viewModel.posts = [post]
        viewModel.deletePost(at: IndexSet(integer: 0))
        XCTAssertTrue(viewModel.posts.isEmpty)
    }
}
