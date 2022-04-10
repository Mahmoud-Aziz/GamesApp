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
    func didSelectItem(at index: Int)
    func loadMoreGames()
    func stateDidChange(state: HomeState)
}

class GamesViewModel {
    // MARK: - Private properties:
    private var gamesCollection: [Response] = []
    private var searchedGames: [Response] = []
    private var paginationGames: [Response] = []
    private var paginationSearch: [Response] = []
    private let dataSource: GamesUseCase
    private let state: StatePresentable
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var gamesLimit = 10
    private var gamesPerPage = 10
    private var currentPage = 1
    private var currentState: HomeState = .notSearching
    private let gamesStore: LocalJSONStore<[Response]> = LocalJSONStore(storageType: .cache, filename: "games.json")

    // MARK: - Initializer:
    init(dataSource: GamesUseCase, statePresenter: StatePresentable) {
        self.dataSource = dataSource
        self.state = statePresenter
    }
}

// MARK: - Use case execution:
private extension GamesViewModel {
    func getGames(page: Int) {
        dataSource.getGames(page: page.toString, completion: { [weak self] result in
            self?.handleGamesResults(result: result)
        })
    }
    
    func search(with text: String, page: Int) {
        pendingRequestWorkItem?.cancel()
        if text.isEmpty {
            currentState = .notSearching
            getGames(page: currentPage)
        } else {
            currentState = .searching(text: text)
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.state.render(state: .loading)
                self.dataSource.search(for: text, page: page.toString, completion: {[weak self] result in
                    self?.handleSearchResult(query: text, result: result)
                })
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                          execute: requestWorkItem)
        }
    }
}

// MARK: - Handle use case results:
private extension GamesViewModel {
    func handleGamesResults(result: GamesResultHandler) {
        var gamesResponse: [Response] = []
        switch result {
        case .success(let games):
            guard let results = games.results else {
                state.render(state: .error(ViewError.operationFaield.rawValue))
                return
            }
            if let cachedGames = gamesStore.storedValue {
                gamesResponse = cachedGames
            } else {
                gamesResponse = results
                gamesStore.save(results)
            }
            gamesCollection = gamesResponse
            gamesPerPage = results.count
            gamesLimit = games.count
            for game in 0..<results.count {
                paginationGames.append(results[game])
            }
            setPaginationGames(gamesPerPage: results.count)
            state.render(state: .loaded)
        case .failure(let error):
            state.render(state: .error(NetworkError.failedRequest.rawValue))
            state.render(state: .loaded)
            print("Error occured in URLSession request: \(error.localizedDescription)", logLevel: .error)
        }
    }
    
    func handleSearchResult(query: String, result: GamesResultHandler) {
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
            gamesPerPage = results.count
            gamesLimit = results.count
            for game in 0..<results.count {
                paginationSearch.append(results[game])
            }
            setPaginationSearch(gamesPerPage: gamesPerPage)
            state.render(state: .loaded)
        case .failure(let error):
            state.render(state: .empty)
            state.render(state: .loaded)
            print("Error occured in Search: \(error.localizedDescription)", logLevel: .error)
        }
    }
}

// MARK: - Setup pagination:
private extension GamesViewModel {
    func setPaginationGames(gamesPerPage: Int) {
        if gamesPerPage >= gamesLimit {
            return
        } else {
            if gamesPerPage >= gamesLimit - gamesPerPage {
                for game in gamesPerPage..<gamesLimit {
                    paginationGames.append(gamesCollection[game])
                }
                self.gamesPerPage += gamesCollection.count
                self.currentPage += 1
            } else {
                self.gamesPerPage += gamesCollection.count
                self.currentPage += 1
            }
        }
    }
    
    func setPaginationSearch(gamesPerPage: Int) {
            if gamesPerPage >= gamesLimit - gamesPerPage {
                for game in gamesPerPage..<gamesLimit {
                    paginationSearch.append(searchedGames[game])
                }
                self.gamesPerPage += searchedGames.count
                self.currentPage += 1
            } else {
                self.gamesPerPage += searchedGames.count
                self.currentPage += 1
            }
            self.state.render(state: .loaded)
        }
    }

// MARK: - GamesViewModelProtocol conformance:
extension GamesViewModel: GamesViewModelProtocol {
    var numberOfItems: Int {
        currentState == .notSearching ? paginationGames.count : paginationSearch.count
    }
    
    func viewDidLoad() {
        state.render(state: .initial)
        getGames(page: currentPage)
    }
    
    func search(with text: String) {
        paginationSearch.removeAll()
        state.render(state: .populated)
        search(with: text, page: currentPage)
    }
    
    func loadMoreGames() {
        state.render(state: .loadingMore)
        switch currentState {
        case .searching(text: let text):
            search(with: text, page: currentPage)
        case .notSearching:
            getGames(page: currentPage)
        }
    }
    
    func getGames(at index: Int) -> Response? {
        state.render(state: .populated)
        return currentState == .notSearching ? paginationGames[safe: index] : paginationSearch[safe: index]
    }
    
    func didSelectItem(at index: Int) {
        switch currentState {
        case .notSearching:
            state.render(state: .navigate(paginationGames[index]))
        case .searching:
            state.render(state: .navigate(paginationSearch[index]))
        }
    }
    
    func stateDidChange(state: HomeState) {
        switch state {
        case .notSearching:
            currentState = .notSearching
        default:
            currentState = .notSearching
        }
    }
}
