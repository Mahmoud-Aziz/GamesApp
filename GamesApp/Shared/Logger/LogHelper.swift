//
//  Base.swift
//  Logger
//
//  Created by Mahmoud Aziz on 04/01/2022.
//

import Foundation
import UIKit

// MARK: - Public Helpers
let printSeparator = " "
let printTernimator = "\n"

class Logger {
    static let shared: Logger = .init()

    func log(logLevel: LogLevel = .info,
             output: String,
             separator: String = printSeparator,
             terminator: String = printTernimator,
             function: String = #function,
             file: String = #file,
             line: Int = #line,
             column: Int = #column) {
        
        let level = prefixLevel(logLevel: logLevel)
#if DEBUG
        Swift.print(
            """
        \(level)
        [
            function: \(function)
            file: \((file as NSString).lastPathComponent)
            line: \(line)
            column: \(column)
            Message: \(context.input)
        ]
        """
        )
#endif
    }

    // MARK: - Private Helpers
    private func prefixLevel(logLevel: LogLevel) -> String {
        return "\(logLevel.prefix ?? "")"
    }
    
    private func date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}

/// Customized Print function for logging
func print<T>(_ input: T...,
              logLevel: LogLevel = .info,
              separator: String = printSeparator,
              terminator: String = printTernimator,
              function: String = #function,
              file: String = #file,
              line: Int = #line,
              column: Int = #column) {
    
    let output = input.map { "\($0)" }.joined(separator: separator)
    Logger.shared.log(
        logLevel: logLevel,
        output: output,
        separator: separator,
        terminator: terminator,
        function: function,
        file: file,
        line: line,
        column: column
    )
}

func print<T>(_ input: T?...,
              logLevel: LogLevel = .info,
              separator: String = printSeparator,
              terminator: String = printTernimator,
              function: String = #function,
              file: String = #file,
              line: Int = #line,
              column: Int = #column) {
    let output = input.map { item in
        if let item = item { return "\(item)" } else { return "(nil)" }
    }.joined(separator: separator)
    Logger.shared.log(
        logLevel: logLevel,
        output: output,
        separator: separator,
        terminator: terminator,
        function: function,
        file: file,
        line: line,
        column: column
    )
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let output = items.map { "\($0)" }.joined(separator: separator)
    Logger.shared.log(
        logLevel: .info,
        output: output,
        separator: separator,
        terminator: terminator,
        function: #function,
        file: #file,
        line: #line,
        column: #column
    )
}
