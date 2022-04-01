//
//  GamesDataProvider.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation
typealias GamesResultHandler = Result<[GamesResponse], Error>
typealias GamesReponseHandler = (GamesResultHandler) -> Void

class GamesDataProvider: GamesUseCase {
    func getGames(completion: @escaping GamesReponseHandler) {
    
    }
}
