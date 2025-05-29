
import SwiftUI

final class AppData: ObservableObject {
    
    // MARK: - Published Properties

    @Published var isStorageSelected: Bool = false
    @Published var storageType: StorageType?
}
