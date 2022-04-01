//
//  SearchResponse.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let count: Int?
    let next: String?
    let previous: SearchJSONNull?
    let results: [SearchResult]?
    let userPlatforms: Bool?

    enum CodingKeys: String, CodingKey {
        case count, next, previous, results
        case userPlatforms = "user_platforms"
    }
}

// MARK: - Result
struct SearchResult: Codable {
    let slug, name: String?
    let playtime: Int?
    let platforms: [Platform]?
    let stores: [SearchStore]?
    let released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [SearchRating]?
    let ratingsCount, reviewsTextCount, added: Int?
    let addedByStatus: SearchAddedByStatus?
    let metacritic: Int?
    let suggestionsCount: Int?
    let updated: String?
    let id: Int?
    let score: String?
    let clip: SearchJSONNull?
    let tags: [Tag]?
    let esrbRating: SearchEsrbRating?
    let userGame: SearchJSONNull?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: SearchColor?
    let shortScreenshots: [SearchShortScreenshot]?
    let parentPlatforms: [Platform]?
    let genres: [SearchGenre]?
    let communityRating: Int?

    enum CodingKeys: String, CodingKey {
        case slug, name, playtime, platforms, stores, released, tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic
        case suggestionsCount = "suggestions_count"
        case updated, id, score, clip, tags
        case esrbRating = "esrb_rating"
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case shortScreenshots = "short_screenshots"
        case parentPlatforms = "parent_platforms"
        case genres
        case communityRating = "community_rating"
    }
}

// MARK: - AddedByStatus
struct SearchAddedByStatus: Codable {
    let yet, owned, beaten, toplay: Int?
    let dropped, playing: Int?
}

enum SearchColor: String, Codable {
    case the0F0F0F = "0f0f0f"
}

// MARK: - EsrbRating
struct SearchEsrbRating: Codable {
    let id: Int?
    let name, slug, nameEn, nameRu: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case nameEn = "name_en"
        case nameRu = "name_ru"
    }
}

// MARK: - Genre
struct SearchGenre: Codable {
    let id: Int?
    let name, slug: String?
}

// MARK: - Platform
struct Platform: Codable {
    let platform: SearchGenre?
}

// MARK: - Rating
struct SearchRating: Codable {
    let id: Int?
    let title: SearchTitle?
    let count: Int?
    let percent: Double?
}

enum SearchTitle: String, Codable {
    case exceptional = "exceptional"
    case meh = "meh"
    case recommended = "recommended"
    case skip = "skip"
}

// MARK: - ShortScreenshot
struct SearchShortScreenshot: Codable {
    let id: Int?
    let image: String?
}

// MARK: - Store
struct SearchStore: Codable {
    let store: SearchGenre?
}

// MARK: - Tag
struct Tag: Codable {
    let id: Int?
    let name, slug: String?
    let language: SearchLanguage?
    let gamesCount: Int?
    let imageBackground: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, language
        case gamesCount = "games_count"
        case imageBackground = "image_background"
    }
}

enum SearchLanguage: String, Codable {
    case eng = "eng"
    case rus = "rus"
}

// MARK: - Encode/decode helpers

class SearchJSONNull: Codable, Hashable {

    public static func == (lhs: SearchJSONNull, rhs: SearchJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(SearchJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
