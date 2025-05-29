
import SwiftUI

struct AppRootView: View {
    
    // MARK: - State

    @State private var selectedStorageType: StorageType? = nil

    // MARK: - Body

    var body: some View {
        ZStack {
            if let type = selectedStorageType {
                let viewModel = ViewModelFactory.makePostsViewModel(for: type)

                MainTabView(viewModel: viewModel, storageType: type)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            } else {
                WelcomeView { selected in
                    withAnimation {
                        selectedStorageType = selected
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: selectedStorageType)
    }
}
