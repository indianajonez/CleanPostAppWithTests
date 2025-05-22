//
//  CDPost+CoreDataProperties.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import Foundation
import CoreData

// MARK: - CDPost CoreData Properties

extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var isFavorite: Bool
}

// MARK: - Identifiable Conformance

extension CDPost: Identifiable { }

