//
//  FavouritesUseCase.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import CoreData

typealias FavoritesResultHandler = Result<[Favorite], Error>

protocol FavouritesUseCase {
    func fetchFavorites(completion: @escaping (FavoritesResultHandler) -> Void)
    func removeFavorite(object: NSManagedObject)
}
