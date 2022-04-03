//
//  Configurations.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

enum Configuration {
     enum Error: Swift.Error {
         case missingKey, invalidValue
     }

     static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
         guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
             throw Error.missingKey
         }

         switch object {
         case let string as String:
             guard let value = T(string) else { fallthrough }
             return value
         default:
             throw Error.invalidValue
         }
     }
}
