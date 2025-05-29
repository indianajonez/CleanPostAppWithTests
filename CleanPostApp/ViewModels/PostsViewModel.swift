
import Foundation

final class PostsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var networkState: NetworkState = .connected
    
    // MARK: - Private properties

    private let storage: PostStorageProtocol
    private let networkService: NetworkServiceProtocol

    private var currentPage = 1
    private var isLoadingPage = false
    private var allPagesLoaded = false
    
    //MARK: - Computer properties
    
    var favoritePosts: [Post] {
        posts.filter { $0.isFavorite }
    }
    
    var alertMessage: String? {
        networkState.alertMessage
    }
    
    // MARK: - Init

    init(storage: PostStorageProtocol, networkService: NetworkServiceProtocol = NetworkService()) {
        self.storage = storage
        self.networkService = networkService
        loadInitialData()
    }
    
    // MARK: - Public methods

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
    func refreshPosts() async {
        currentPage = 1
        allPagesLoaded = false

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

    func deletePost(at offsets: IndexSet) {
        let postsToDelete = offsets.map { posts[$0] }
        let filtered = postsToDelete.filter { $0.userId == 0 }
        posts.removeAll { post in
            filtered.contains(where: { $0.id == post.id })
        }
        save()
    }
    
    // MARK: - Private methods
    
    private func loadInitialData() {
        let saved = storage.loadPosts()
        let favoriteIds = storage.loadFavoriteIds()

        posts = saved.map { post in
            var updated = post
            updated.isFavorite = favoriteIds.contains(post.id)
            return updated
        }

        Task { await fetchNextPage() }
    }
    
    private func save() {
        storage.save(posts: posts)
        let favs = posts.filter { $0.isFavorite }.map { $0.id }
        storage.saveFavoriteIds(favs)
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
}
