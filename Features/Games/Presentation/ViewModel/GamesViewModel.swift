//
//  GamesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation
import UIKit

enum HomeState: Equatable {
    case searching(text: String)
    case notSearching
}

protocol GamesViewModelProtocol {
    var numberOfItems: Int { get }
    func viewDidLoad()
    func getGames(at index: Int) -> Response?
    func search(with text: String)
}

class GamesViewModel {
    //MARK: - Private properties:
    private var gamesCollection: [Response] = []
    private var searchedGames: [Response] = []
    private let dataSource: GamesUseCase
    private let state: StatePresentable
    private var hasMoreItems = true
    private(set) var currentState: HomeState = .notSearching
    private var pendingRequestWorkItem: DispatchWorkItem?

    //MARK: - Initializer:
    init(dataSource: GamesUseCase, statePresenter: StatePresentable) {
        self.dataSource = dataSource
        self.state = statePresenter
    }
    
    //MARK: - Data Source execution:
    private func getGames() {
        dataSource.getGames(completion: { [weak self] result in
            switch result {
            case .success(let games):
                guard let results = games.results else { return }
                self?.gamesCollection = results
                self?.state.render(state: .loaded)
            case .failure(let error):
                self?.state.render(state: .error(NetworkError.failedRequest.rawValue))
                //TODO: Log error
            }
        })
    }
}

//MARK: - GamesViewModelProtocol conformance:
extension GamesViewModel: GamesViewModelProtocol {
    var numberOfItems: Int {
        currentState == .notSearching ? gamesCollection.count : searchedGames.count
    }
    
    func viewDidLoad() {
        state.render(state: .initial)
        getGames()
    }
    
    func getGames(at index: Int) -> Response? {
        currentState == .notSearching ? gamesCollection[safe: index] : searchedGames[safe: index]
    }
    
    func search(with text: String) {
        searchedGames.removeAll()
        pendingRequestWorkItem?.cancel()
        if text.isEmpty {
            currentState = .notSearching
            getGames()
        } else {
            currentState = .searching(text: text)
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.currentState = .searching(text: text)
                self.dataSource.search(for: text, completion:  { [weak self] result in
                    guard let self = self else { return }
                    self.state.render(state: .loading)
                    self.handleSearchResult(result: result)
                })
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000),
                                          execute: requestWorkItem)
        }
    }
    
    func handleSearchResult(result: GamesResultHandler) {
        switch result {
        case .success(let games):
            guard let results = games.results else {
                state.render(state: .error(SearchError.noResults.rawValue))
                return
            }
            guard results.count != 0 else {
                state.render(state: .error(SearchError.noResults.rawValue))
                return
            }
            searchedGames = results
            state.render(state: .loaded)
        case .failure(let error):
            //TODO: Log error
            state.render(state: .error(NetworkError.failedRequest.rawValue))
        }
    }
}
