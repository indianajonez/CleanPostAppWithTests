//
//  AppData.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import SwiftUI

// MARK: - AppData

final class AppData: ObservableObject {
    
    // MARK: - Published Properties

    @Published var isStorageSelected: Bool = false
    @Published var storageType: StorageType?
}
