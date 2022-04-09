//
//  Encodable.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 31/03/2022.
//

import Foundation

extension Encodable {
    // Convert encodable data to dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let json = object as? [String: Any] else {
        let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object isn't dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return json
    }
}
