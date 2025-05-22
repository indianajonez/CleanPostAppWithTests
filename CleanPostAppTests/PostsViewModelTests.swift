//
//  PostsViewModelTests.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 20.05.2025.
//

import XCTest
import Combine
@testable import CleanPostApp

// MARK: - PostsViewModelTests

final class PostsViewModelTests: XCTestCase {
    
    // MARK: - Properties

    var viewModel: PostsViewModel!
    var storage: MockPostStorage!
    var network: MockNetworkService!
    var cancellables: Set<AnyCancellable>!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        storage = MockPostStorage()
        network = MockNetworkService()
        viewModel = PostsViewModel(storage: storage, networkService: network)
        cancellables = []
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
