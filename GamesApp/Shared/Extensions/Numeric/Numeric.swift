//
//  Numeric.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

protocol NumericToString {
    var toString: String { get }
}
extension NumericToString {
    var toString: String {
        return "\(self)"
    }
}
extension Float: NumericToString { }
extension Double: NumericToString { }
extension Int: NumericToString { }
extension UInt: NumericToString { }
extension Int8: NumericToString { }
extension Int16: NumericToString { }
extension Int32: NumericToString { }
extension Int64: NumericToString { }
