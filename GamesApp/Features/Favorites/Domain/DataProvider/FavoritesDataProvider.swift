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
    func fetchFavorites(completion: @escaping (favoritesResultHandler) -> Void) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        context.perform {
            do {
                let result = try fetchRequest.execute()
                completion(.success(result))
            } catch {
                //TODO: Log error
                completion(.failure(error))
            }
        }
    }
    
    func removeFavorite(object: NSManagedObject) {
        context.delete(object)
            do {
              try context.save()
            } catch {
                print("error saving")
                //TODO: Log error
            }
    }
}
