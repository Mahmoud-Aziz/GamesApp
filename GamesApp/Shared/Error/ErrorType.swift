//
//  ErrorType.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

enum NetworkError: String {
    case failedRequest = "Something unexpected occured, Please try again."
}

enum ViewError: String {
    case operationFaield = "The operation couldn't be completed"
    case alert = "We have a problem!"
}

enum SearchError: String {
    case noResults = "We couldn't find a mathing game :("
}

enum Placeholder: String {
    case title = "No available name"
    case genre = "No available genre"
    case score = "No available score"
}
