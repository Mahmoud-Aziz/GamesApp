//
//  GamesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import Foundation
import UIKit

protocol GamesViewModelProtocol {
    var numberOfItems: Int { get }
    func viewDidLoad()
    func getGame(for index: Int) -> Response
}

class GamesViewModel {
    //MARK: - Private properties:
    private var gamesCollection: [Response] = []
    private let dataSource: GamesUseCase
    private let state: StatePresentable
    
    //MARK: - Initializer:
    init(dataSource: GamesUseCase, statePresenter: StatePresentable) {
        self.dataSource = dataSource
        self.state = statePresenter
    }
    
    //MARK: - Data Source execution:
    func getGames() {
        dataSource.getGames(completion: { [weak self] result in
            self?.state.render(state: .loading)
            switch result {
            case .success(let games):
                self?.gamesCollection = games[0].results
                self?.state.render(state: .loaded)
            case .failure(let error):
                self?.state.render(state: .error(error))
                //TODO: Log error
            }
        })
    }
}

//MARK: - GamesViewModelProtocol conformance:
extension GamesViewModel: GamesViewModelProtocol {
    var numberOfItems: Int {
        gamesCollection.count
    }
    
    func viewDidLoad() {
        state.render(state: .initial)
        getGames()
    }
    
    func getGame(for index: Int) -> Response {
        gamesCollection[index]
    }
}
