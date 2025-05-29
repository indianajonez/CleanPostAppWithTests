
import SwiftUI

struct MainTabView: View {
    
    // MARK: - Properties

    @ObservedObject var viewModel: PostsViewModel
    let storageType: StorageType

    // MARK: - Body

    var body: some View {
        TabView {
            NavigationView {
                PostsListView(viewModel: viewModel, storageType: storageType)
                    .navigationTitle("Посты")
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
