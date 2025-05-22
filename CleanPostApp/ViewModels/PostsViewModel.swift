//
//  PostsViewModel.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import Foundation
import Combine
import Network

// MARK: - PostsViewModel

class PostsViewModel: ObservableObject {
    
    // MARK: - Published Properties

    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isOffline = false
    @Published var isServerUnreachable = false

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let storage: PostStorageProtocol
    private let networkService: NetworkServiceProtocol

    private var currentPage = 1
    private var isLoadingPage = false
    private var allPagesLoaded = false

    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")

    // MARK: - Init

    init(storage: PostStorageProtocol, networkService: NetworkServiceProtocol = NetworkService()) {
        self.storage = storage
        self.networkService = networkService
        observeNetwork()
        loadInitialData()
    }

    // MARK: - Network Monitoring

    private func observeNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOffline = (path.status != .satisfied)
            }
        }
        monitor.start(queue: monitorQueue)
    }

    // MARK: - Data Loading

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

    func fetchNextPage() {
        guard !isLoadingPage, !allPagesLoaded else { return }
        isLoadingPage = true
        isLoading = true

        networkService.fetchPosts(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoadingPage = false
                self.isLoading = false

                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isServerUnreachable = false

                    if let urlError = error as? URLError {
                        switch urlError.code {
                        case .cannotConnectToHost, .cannotFindHost:
                            self.isServerUnreachable = true
                        default:
                            break
                        }
                    }
                }
            } receiveValue: { [weak self] newPosts in
                guard let self = self else { return }

                self.isServerUnreachable = false

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

    func refreshPosts() {
        currentPage = 1
        allPagesLoaded = false
        posts.removeAll()
        fetchNextPage()
    }

    // MARK: - Post Modification

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
