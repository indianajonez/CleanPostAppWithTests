
import SwiftUI

struct AddPostView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var showAlert = false

    let onSave: (String, String) -> Void

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Заголовок")) {
                    TextField("Введите заголовок", text: $title)
                }

                Section(header: Text("Текст")) {
                    TextEditor(text: $bodyText)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Новый пост")
            .navigationBarItems(
                leading: Button("Отмена") {
                    dismiss()
                },
                trailing: Button("Сохранить") {
                    validateAndSave()
                }
            )
            .alert("Ошибка", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Пожалуйста, заполните все поля перед добавлением поста.")
            }
        }
    }

    // MARK: - Validation

    private func validateAndSave() {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert = true
        } else {
            onSave(title, bodyText)
            dismiss()
        }
    }
}
