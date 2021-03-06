//
//  CoreDataStack.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Favorites")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                print("error loading persistence container: \(error)", logLevel: .error)
            }
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        })
        return container
    }()
    
    func saveContext () throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                print("Error occured in Saving data in core data: \(error.localizedDescription)", logLevel: .error)
            }
        }
    }
}
