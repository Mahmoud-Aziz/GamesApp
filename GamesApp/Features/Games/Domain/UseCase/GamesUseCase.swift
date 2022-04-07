//
//  GamesUseCase.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

protocol GamesUseCase {
    func getGames(page: String, completion: @escaping GamesReponseHandler)
    func search(for: String, completion: @escaping GamesReponseHandler)
}
