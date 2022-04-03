//
//  String.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

extension String {
    var toURL: URL {
        return URL(string: self)!
    }
}
