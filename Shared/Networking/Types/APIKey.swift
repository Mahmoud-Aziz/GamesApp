//
//  APIKey.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

enum APIKey {
    static var apiKey: String {
        return try! Configuration.value(for: "API_KEY")
    }
}
