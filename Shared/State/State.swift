//
//  State.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation

enum State {
    case initial
    case loading
    case loaded
    case error(String)
}

enum EmptyState {
    case loading, loaded
}

protocol EmptyPresentable {
    func spinner(state: EmptyState)
}

protocol ErrorPresentable {
    func show(message: String)
}

protocol StatePresentable: EmptyPresentable, ErrorPresentable {
    func render(state: State)
}
