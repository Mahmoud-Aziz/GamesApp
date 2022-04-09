//
//  DetailsResponse.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

// MARK: - GameDetails
struct DetailsResponse: Codable {
    let name: String?
    let description: String?
    let backgroundImage: String?
    let website: String?
    let redditUrl: String?
    let metacritic: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "description"
        case backgroundImage = "background_image"
        case website
        case redditUrl = "reddit_url"
        case metacritic
        case genres
    }
}
