
import Foundation

final class ViewModelFactory {
    
    //MARK: - public methods
    
    static func makePostsViewModel(for storageType: StorageType) -> PostsViewModel {
        let storage: PostStorageProtocol

        switch storageType {
        case .userDefaults:
            storage = UserDefaultsStorage()
        case .coreData:
            storage = CoreDataStorage() 
        }
        return PostsViewModel(storage: storage)
    }
}
