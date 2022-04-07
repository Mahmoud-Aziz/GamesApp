//
//  GamesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation
import UIKit

enum HomeState: Equatable {
    case searching
    case notSearching
}

protocol GamesViewModelProtocol {
    var numberOfItems: Int { get }
    var currentPage: Int { get set }
    var currentState: HomeState { get set }
    func viewDidLoad()
    func getGames(at index: Int) -> Response?
    func search(with text: String)
    func didSelectItem(at index: Int)
    func setPaginationGames(gamesPerPage: Int)
    func getGames(page: Int)
}

class GamesViewModel {
    //MARK: - Private properties:
    private var gamesCollection: [Response] = []
    private var searchedGames: [Response] = []
    private var paginationGames: [Response] = []
    private let dataSource: GamesUseCase
    private let state: StatePresentable
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var gamesLimit = 10
    private var gamesPerPage : Int = 10
    var currentState: HomeState = .notSearching
    var currentPage = 1
    
    //MARK: - Initializer:
    init(dataSource: GamesUseCase, statePresenter: StatePresentable) {
        self.dataSource = dataSource
        self.state = statePresenter
    }
    
    //MARK: - Data Source execution:
    func getGames(page: Int) {
        dataSource.getGames(page: page.toString, completion: { [weak self] result in
            switch result {
            case .success(let games):
                guard let results = games.results else { return }
                self?.gamesCollection = results
                self?.gamesPerPage = results.count
                self?.gamesLimit = games.count
                for i in 0..<results.count {
                    self?.paginationGames.append(results[i])
                }
                self?.setPaginationGames(gamesPerPage: results.count)
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
        currentState == .notSearching ? paginationGames.count : searchedGames.count
    }
    
    func viewDidLoad() {
        state.render(state: .initial)
        getGames(page: currentPage)
    }
    
    func getGames(at index: Int) -> Response? {
        currentState == .notSearching ? paginationGames[safe: index] : searchedGames[safe: index]
    }
    
    func search(with text: String) {
        searchedGames.removeAll()
        pendingRequestWorkItem?.cancel()
        if text.isEmpty {
            currentState = .notSearching
            getGames(page: currentPage)
        } else {
            currentState = .searching
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.state.render(state: .loading)
                self.dataSource.search(for: text, completion:  { [weak self] result in
                    guard let self = self else { return }
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
    
    func didSelectItem(at index: Int) {
        state.render(state: .navigate(paginationGames[index]))
    }
    
    func setPaginationGames(gamesPerPage: Int) {
        if gamesPerPage >= gamesLimit {
            return
        } else {
            if gamesPerPage >= gamesLimit - gamesPerPage {
                for i in gamesPerPage..<gamesLimit {
                    paginationGames.append(gamesCollection[i])
                }
                self.gamesPerPage += gamesCollection.count
                self.currentPage += 1
            } else {
                self.gamesPerPage += gamesCollection.count
                self.currentPage += 1
            }
            self.state.render(state: .loaded)
        }
    }
}
