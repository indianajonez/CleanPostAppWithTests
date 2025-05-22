//
//  AddPostView.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 16.05.2025.
//

import SwiftUI

// MARK: - AddPostView

struct AddPostView: View {
    
    // MARK: - Environment

    @Environment(\.dismiss) var dismiss

    // MARK: - State

    @State private var title = ""
    @State private var postBody = ""

    // MARK: - Callback

    var onSave: (String, String) -> Void

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Заголовок")) {
                    TextField("Введите заголовок", text: $title)
                }

                Section(header: Text("Текст поста")) {
                    TextField("Введите текст", text: $postBody)
                }
            }
            .navigationTitle("Новый пост")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        guard !title.isEmpty, !postBody.isEmpty else { return }
                        onSave(title, postBody)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
            }
        }
    }
}
