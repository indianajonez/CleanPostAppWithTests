//
//  ContentView.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: PostsViewModel
    let storageType: StorageType

    // MARK: - Body

    var body: some View {
        TabView {
            NavigationView {
                PostsListView(viewModel: viewModel, storageType: storageType)
            }
            .tabItem {
                Label("Все посты", systemImage: "list.bullet")
            }

            NavigationView {
                FavoritesView(viewModel: viewModel)
                    .navigationTitle("Избранное")
            }
            .tabItem {
                Label("Избранное", systemImage: "heart.fill")
            }
        }
        .accentColor(.red)
    }
}
