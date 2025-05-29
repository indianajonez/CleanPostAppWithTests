
import Foundation

enum StorageType: String, CaseIterable {
    case userDefaults
    case coreData
    
    //MARK: - Computer properties

    var description: String {
        switch self {
        case .userDefaults:
            return "UserDefaults"
        case .coreData:
            return "CoreData"
        }
    }

    var iconName: String {
        switch self {
        case .userDefaults:
            return "square.and.arrow.down"
        case .coreData:
            return "archivebox.fill"
        }
    }
}
