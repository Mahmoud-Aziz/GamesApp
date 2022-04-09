//
//  FavoritesDataProvider.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import CoreData

class FavoritesDataProvider: FavouritesUseCase {
    let context = CoreDataStack.shared.persistentContainer.viewContext
    func fetchFavorites(completion: @escaping (FavoritesResultHandler) -> Void) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        context.perform {
            do {
                let result = try fetchRequest.execute()
                completion(.success(result))
            } catch {
                completion(.failure(error))
                print("Error fetching data from core data: \(error.localizedDescription)", logLevel: .error)
            }
        }
    }
    
    func removeFavorite(object: NSManagedObject) {
        context.delete(object)
            do {
              try context.save()
            } catch {
                print("error saving")
                print("Error saving data to core data: \(error.localizedDescription)", logLevel: .error)
            }
    }
}
