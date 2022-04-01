//
//  ImageLoaderError.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

enum ImageLoaderError: Error {
    case unknown
    case imageNotDecoded
    case urlNotCorrect
    case imageNotResized
    case notFound
}
