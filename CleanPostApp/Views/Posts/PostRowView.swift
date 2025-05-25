
import SwiftUI

struct PostRowView: View {

    // MARK: - Properties

    let post: Post
    let isLast: Bool
    let onAppear: () -> Void
    let onToggleFavorite: () -> Void

    // MARK: - Body

    var body: some View {
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

            Button(action: onToggleFavorite) {
                Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(post.isFavorite ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 6)
        .onAppear {
            if isLast {
                onAppear()
            }
        }
    }
}
