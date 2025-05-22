//
//  PostsListView.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import SwiftUI

// MARK: - PostsListView

struct PostsListView: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: PostsViewModel
    let storageType: StorageType
    @State private var showingAddPost = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            header

            // MARK: - Status Banner
            if viewModel.isOffline {
                banner(text: "Нет интернета — показан локальный кэш")
            } else if viewModel.isServerUnreachable {
                banner(text: "Сервер недоступен. Возможно, включён VPN")
            }

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
        .alert("Ошибка", isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil })
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Посты")
                .font(.largeTitle.bold())

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
                ForEach(viewModel.posts.indices, id: \.self) { index in
                    let post = viewModel.posts[index]
                    PostRowView(
                        post: post,
                        isLast: index == viewModel.posts.count - 1,
                        onAppear: {
                            viewModel.fetchNextPage()
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
                viewModel.refreshPosts()
            }
        }
    }

    // MARK: - Banner

    @ViewBuilder
    private func banner(text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(text)
                .font(.footnote)
                .bold()
        }
        .foregroundColor(.orange)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
        .transition(.opacity)
    }
}
