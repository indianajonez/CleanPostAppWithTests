
import SwiftUI

struct PostsListView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: PostsViewModel
    let storageType: StorageType
    @State private var showingAddPost = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
        }
        .padding(.bottom)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddPost = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPost) {
            AddPostView { title, body in
                viewModel.addPost(title: title, body: body)
            }
        }
        .alert("Ошибка", isPresented: .constant(viewModel.alertMessage != nil)) {
            Button("OK", role: .cancel) {
                viewModel.networkState = .connected
            }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(storageType.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.posts.isEmpty {
            Spacer()
            ProgressView("Загрузка постов...")
                .padding()
            Spacer()
        } else if viewModel.posts.isEmpty {
            Spacer()
            VStack(spacing: 10) {
                Image(systemName: "tray")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                Text("Нет постов")
                    .foregroundColor(.gray)
            }
            Spacer()
        } else {
            List {
                ForEach(viewModel.posts) { post in
                    PostRowView(
                        post: post,
                        isLast: post == viewModel.posts.last,
                        onAppear: {
                            Task { await viewModel.fetchNextPage() }
                        },
                        onToggleFavorite: {
                            viewModel.toggleFavorite(for: post)
                        }
                    )
                }
                .onDelete { indexSet in
                    viewModel.deletePost(at: indexSet)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.refreshPosts()
            }
        }
    }
}
