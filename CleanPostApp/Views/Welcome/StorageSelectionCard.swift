//
//  StorageSelectionCard.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import SwiftUI

// MARK: - StorageSelectionCard

struct StorageSelectionCard: View {
    
    // MARK: - Properties

    @Binding var selectedStorage: StorageType?
    var onComplete: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            if selectedStorage == nil {
                Text("Выберите хранилище для ваших записей")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                ForEach(StorageType.allCases, id: \.self) { type in
                    StorageTypeButton(type: type) {
                        withAnimation(.spring()) {
                            selectedStorage = type
                        }
                    }
                }
            } else {
                VStack(spacing: 25) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .symbolEffect(.bounce, value: selectedStorage)

                    Text("Готово к использованию!")
                        .font(.title2)
                        .foregroundColor(.white)

                    Button(action: onComplete) {
                        Text("Начать")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(20)
        .padding(.horizontal, 30)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

// MARK: - StorageTypeButton

struct StorageTypeButton: View {
    
    // MARK: - Properties

    let type: StorageType
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: type.iconName)
                Text(type.description)
                    .font(.system(.body, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.15))
            .cornerRadius(12)
        }
    }
}
