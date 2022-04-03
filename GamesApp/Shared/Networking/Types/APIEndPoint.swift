//
//  APIEndPoint.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

enum APIEndpoint: String {
    case games = "games"
    
    static func deetailsPath(id: Int) -> String {
        return games.rawValue + "/" + id.toString
    }
}
