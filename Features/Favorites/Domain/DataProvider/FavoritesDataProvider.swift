//
//  FavoritesDataProvider.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import CoreData

class FavoritesDataProvider: FavouritesUseCase {
    func fetchFavorites(completion: @escaping (favoritesResultHandler) -> Void) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        CoreDataStack.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                completion(.success(result))
            } catch {
                //TODO: Log error
                completion(.failure(error))
            }
        }
    }
}
