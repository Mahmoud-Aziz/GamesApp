//
//  UseCase.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

protocol DetailsUseCase {
    func getDetails(completion: @escaping DetailsReponseHandler)
}
