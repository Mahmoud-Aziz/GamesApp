//
//  APIBaseURL.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

enum APIBaseURL {
    static var baseURL: URL {
        return try! URL(string: Configuration.value(for: "API_BASE_URL"))!
    }
}
