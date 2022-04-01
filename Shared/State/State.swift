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
    case error(Error)
}

enum EmptyState {
    case visible, hidden
}

protocol EmptyPresentable {
    func setEmptyView(state: EmptyState)
}

protocol ErrorPresentable {
    func show(error: Error)
}

protocol StatePresentable: EmptyPresentable, ErrorPresentable {
    func render(state: State)
}
