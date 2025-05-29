
import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Public properties
    
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Private properties
    
    private let container: NSPersistentContainer
    
    // MARK: - Init

    private init() {
        container = NSPersistentContainer(name: "CleanPostModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка при загрузке хранилища CoreData: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Public Methods

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
