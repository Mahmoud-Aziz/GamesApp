//
//  GamesResponse.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

struct GamesResponse: Codable {
    let results: [Response]?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Response: Codable {
    let id: Int
    let name: String?
    let backgroundImage: String?
    let metacritic: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case metacritic
        case genres
    }
}

struct Genre: Codable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
