//
//  ViewModelFactory.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import Foundation

// MARK: - StorageType

enum StorageType: String, CaseIterable {
    case userDefaults
    case coreData

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

// MARK: - ViewModelFactory

final class ViewModelFactory {
    static func makePostsViewModel(for storageType: StorageType) -> PostsViewModel {
        let storage: PostStorageProtocol

        switch storageType {
        case .userDefaults:
            storage = UserDefaultsStorage()
        case .coreData:
            storage = CoreDataStorage() // позже добавим реализацию
        }

        return PostsViewModel(storage: storage)
    }
}
