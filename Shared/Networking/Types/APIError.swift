//
//  APIError.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

enum APIError: Error {
    case unknown
    case unreachable
    case unauthorized
    case failedRequest
    case invalidResponse
    case decodeFailure
}
