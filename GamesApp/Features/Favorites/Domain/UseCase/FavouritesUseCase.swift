//
//  FavouritesUseCase.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import CoreData

typealias favoritesResultHandler = Result<[Favorite], Error>

protocol FavouritesUseCase {
    func fetchFavorites(completion: @escaping (favoritesResultHandler) -> Void)
    func removeFavorite(object: NSManagedObject)
}

