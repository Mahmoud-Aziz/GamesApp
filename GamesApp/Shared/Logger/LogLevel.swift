//
//  LogLevel.swift
//  Logger
//
//  Created by Mahmoud Aziz on 04/01/2022.
//

import Foundation

enum LogLevel: String, Codable {
    case info = "INFO ℹ️"
    case warning = "WARNING ⚠️"
    case error = "ERROR ❌"
    
     var prefix: String? {
        switch self {
        case .info: return "INFO ℹ️"
        case .warning: return "WARNING ⚠️"
        case .error: return "ERROR ❌"
        }
    }
}
