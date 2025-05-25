//
//  CoreDataManager.swift
//  CleanPostApp
//
//  Created by Ekaterина Saveleva on 19.05.2025.
//

import Foundation
import CoreData

// MARK: - CoreDataManager

final class CoreDataManager {
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()

    // MARK: - Core Data Stack

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "CleanPostModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка при загрузке хранилища CoreData: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Context Access

    var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Saving Support

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                #if DEBUG
                assertionFailure("❌ Ошибка сохранения CoreData: \(error.localizedDescription)")
                #endif
            }
        }
    }
}


