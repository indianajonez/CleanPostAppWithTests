
import SwiftUI

struct WelcomeView: View {
    
    // MARK: - Properties

    var onSelect: (StorageType) -> Void

    // MARK: - State

    @State private var selectedStorage: StorageType?
    @State private var isAnimating = false

    // MARK: - Body

    var body: some View {
        ZStack {
            AnimatedGradient()
                .ignoresSafeArea()

            VStack {
                Spacer()

                JournalLogoView(isAnimating: $isAnimating)
                    .padding(.bottom, 30)

                VStack(spacing: 8) {
                    Text("Добро пожаловать в")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))

                    Text("CleanPostApp")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                .padding(.bottom, 40)

                StorageSelectionCard(selectedStorage: $selectedStorage) {
                    if let selected = selectedStorage {
                        onSelect(selected)
                    }
                }

                Spacer()
            }
            .padding(.vertical, 40)
        }
        .onAppear {
            startAnimation()
        }
    }

    // MARK: - Animation

    private func startAnimation() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            isAnimating.toggle()
        }
    }
}
