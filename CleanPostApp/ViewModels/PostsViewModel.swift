//
//  PostsViewModel.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import Foundation
import Combine

// MARK: - PostsViewModel

final class PostsViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var networkState: NetworkState = .connected

    // MARK: - Computed

    var alertMessage: String? {
        networkState.alertMessage
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let storage: PostStorageProtocol
    private let networkService: NetworkServiceProtocol
    private let networkMonitor: NetworkMonitor

    private var currentPage = 1
    private var isLoadingPage = false
    private var allPagesLoaded = false

    // MARK: - Init

    init(
        storage: PostStorageProtocol,
        networkService: NetworkServiceProtocol = NetworkService(),
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.storage = storage
        self.networkService = networkService
        self.networkMonitor = networkMonitor
        observeNetwork()
        loadInitialData()
    }

    // MARK: - Network Monitoring

    private func observeNetwork() {
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                if !isConnected {
                    self.networkState = .offline
                } else if self.networkState == .offline {
                    self.networkState = .connected
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Initial Load

    private func loadInitialData() {
        let saved = storage.loadPosts()
        let favoriteIds = storage.loadFavoriteIds()
        self.posts = saved.map { post in
            var updated = post
            updated.isFavorite = favoriteIds.contains(post.id)
            return updated
        }
        fetchNextPage()
    }

    // MARK: - Networking

    func fetchNextPage() {
        guard !isLoadingPage, !allPagesLoaded else { return }
        isLoadingPage = true
        isLoading = true

        networkService.fetchPosts(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                self.isLoadingPage = false

                if case .failure(let error) = completion {
                    if !self.networkMonitor.isConnected {
                        self.networkState = .offline
                    } else {
                        self.networkState = .generalError(error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] newPosts in
                guard let self else { return }

                if self.networkState != .offline {
                    self.networkState = .connected
                }

                if newPosts.isEmpty {
                    self.allPagesLoaded = true
                } else {
                    let favoriteIds = self.storage.loadFavoriteIds()
                    let processed = newPosts.map { post in
                        var updated = post
                        updated.isFavorite = favoriteIds.contains(post.id)
                        return updated
                    }
                    self.posts.append(contentsOf: processed)
                    self.currentPage += 1
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    func refreshPosts() {
        currentPage = 1
        allPagesLoaded = false
        posts.removeAll()
        fetchNextPage()
    }

    func toggleFavorite(for post: Post) {
        guard let index = posts.firstIndex(of: post) else { return }
        posts[index].isFavorite.toggle()
        save()
    }

    func addPost(title: String, body: String) {
        let nextId = (posts.map { $0.id }.max() ?? 0) + 1
        let newPost = Post(id: nextId, userId: 0, title: title, body: body)
        posts.insert(newPost, at: 0)
        save()
    }

    var favoritePosts: [Post] {
        posts.filter { $0.isFavorite }
    }

    func deletePost(at offsets: IndexSet) {
        let postsToDelete = offsets.map { posts[$0] }
        let filtered = postsToDelete.filter { $0.userId == 0 }
        posts.removeAll { post in
            filtered.contains(where: { $0.id == post.id })
        }
        save()
    }

    // MARK: - Persistence

    private func save() {
        storage.save(posts: posts)
        let favs = posts.filter { $0.isFavorite }.map { $0.id }
        storage.saveFavoriteIds(favs)
    }
}

