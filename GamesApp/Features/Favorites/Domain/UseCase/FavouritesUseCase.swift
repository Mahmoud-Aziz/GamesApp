//
//  FavouritesUseCase.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

typealias favoritesResultHandler = Result<[Favorite], Error>

protocol FavouritesUseCase {
    func fetchFavorites(completion: @escaping (favoritesResultHandler) -> Void)
}

