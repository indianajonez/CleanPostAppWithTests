//
//  PostsViewModel.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import Foundation

// MARK: - PostsViewModel

final class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var networkState: NetworkState = .connected

    private let storage: PostStorageProtocol
    private let networkService: NetworkServiceProtocol

    private var currentPage = 1
    private var isLoadingPage = false
    private var allPagesLoaded = false

    init(storage: PostStorageProtocol, networkService: NetworkServiceProtocol = NetworkService()) {
        self.storage = storage
        self.networkService = networkService
        loadInitialData()
    }

    func loadInitialData() {
        let saved = storage.loadPosts()
        let favoriteIds = storage.loadFavoriteIds()

        posts = saved.map { post in
            var updated = post
            updated.isFavorite = favoriteIds.contains(post.id)
            return updated
        }

        Task { await fetchNextPage() }
    }

    @MainActor
    func fetchNextPage() async {
        guard !isLoadingPage, !allPagesLoaded else { return }

        isLoadingPage = true
        isLoading = true

        do {
            let newPosts = try await networkService.fetchPosts(page: currentPage)
            handleNewPosts(newPosts)
        } catch {
            handleError(error)
        }

        isLoadingPage = false
        isLoading = false
    }

    @MainActor
    private func handleNewPosts(_ newPosts: [Post]) {
        if networkState != .offline {
            networkState = .connected
        }

        guard !newPosts.isEmpty else {
            allPagesLoaded = true
            return
        }

        let favoriteIds = storage.loadFavoriteIds()
        let processed = newPosts.map { post in
            var updated = post
            updated.isFavorite = favoriteIds.contains(post.id)
            return updated
        }

        posts.append(contentsOf: processed)
        currentPage += 1
    }

    @MainActor
    private func handleError(_ error: Error) {
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            networkState = .offline
        } else {
            networkState = .generalError(error.localizedDescription)
        }
    }

    @MainActor
    func refreshPosts() async {
        currentPage = 1
        allPagesLoaded = false

        // 🛠 Заново подгружаем кастомные посты перед загрузкой с API
        let saved = storage.loadPosts()
        let favoriteIds = storage.loadFavoriteIds()

        posts = saved.map { post in
            var updated = post
            updated.isFavorite = favoriteIds.contains(post.id)
            return updated
        }

        await fetchNextPage()
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

    private func save() {
        storage.save(posts: posts)
        let favs = posts.filter { $0.isFavorite }.map { $0.id }
        storage.saveFavoriteIds(favs)
    }

    var alertMessage: String? {
        networkState.alertMessage
    }
}
