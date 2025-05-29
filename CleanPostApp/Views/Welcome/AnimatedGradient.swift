
import SwiftUI

// MARK: - AnimatedGradient

struct AnimatedGradient: View {
    
    // MARK: - State

    @State private var start = UnitPoint.topLeading
    @State private var end = UnitPoint.bottomTrailing

    // MARK: - Body

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray, Color.red.opacity(0.8)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                start = .bottomTrailing
                end = .topLeading
            }
        }
    }
}
