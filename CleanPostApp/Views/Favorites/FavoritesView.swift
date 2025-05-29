//
//  FavoritesView.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: PostsViewModel

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.favoritePosts.isEmpty {
                emptyStateView
            } else {
                favoritesList
            }
        }
        .navigationTitle("Избранное")
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))

            Text("Список избранного пуст")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text("Добавляйте посты в избранное, нажимая на сердечко в списке постов")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Favorites List

    private var favoritesList: some View {
        List {
            ForEach(viewModel.favoritePosts) { post in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(post.title)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Text(post.body)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: {
                        viewModel.toggleFavorite(for: post)
                    }) {
                        Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(post.isFavorite ? .red : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.vertical, 6)
            }
        }
        .listStyle(.plain)
    }
}
