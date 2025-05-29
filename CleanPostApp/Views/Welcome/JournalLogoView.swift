
import SwiftUI

// MARK: - JournalLogoView

struct JournalLogoView: View {
    
    // MARK: - Binding

    @Binding var isAnimating: Bool

    // MARK: - Body

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 180, height: 180)
                .scaleEffect(isAnimating ? 1.2 : 0.8)

            Image(systemName: "book.closed.fill")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .shadow(radius: 10)
                .symbolEffect(.bounce, value: isAnimating)
        }
    }
}
