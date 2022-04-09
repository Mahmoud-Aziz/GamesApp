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
    case navigate(Response)
    case empty
    case populated
    case loadingMore
}

enum LoadingState {
    case loading, loaded
}

protocol LoadingPresentable {
    func activityIndicator(state: LoadingState)
}

protocol ErrorPresentable {
    func show(message: String)
}

protocol StatePresentable: LoadingPresentable, ErrorPresentable {
    func render(state: State)
}

protocol NavigationRoute {
    func navigate(to route: Route)
}
