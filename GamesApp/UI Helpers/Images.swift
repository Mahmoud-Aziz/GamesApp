//
//  Images.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit

enum Images {
    case games
    case gamesSelected
    case favorites
    case favoritesSelected
    case placeholder
    
    var image: UIImage {
        switch self {
        case .games:
            return UIImage(named: "Games")!
        case .gamesSelected:
            return UIImage(named: "Games-Selected")!
        case .favorites:
            return UIImage(named: "Favorites")!
        case .favoritesSelected:
            return UIImage(named: "Favorites-Selected")!
        case .placeholder:
            return UIImage(named: "placeholder")!

        }
    }
}
