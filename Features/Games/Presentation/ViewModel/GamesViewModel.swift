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
    func getTitle( for index: Int) -> String
    func getGenres( for index: Int) -> String
    func getMetacritic( for index: Int) -> Int
    func getImage( for index: Int) -> String
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
    func viewDidLoad() {
        getGames()
    }
    
    var numberOfItems: Int {
        gamesCollection.count
    }
    
    func getGame(for index: Int) -> Response {
        gamesCollection[index]
    }
    
    func getTitle( for index: Int) -> String {
        gamesCollection[index].name ?? ""
    }
    
    func getGenres( for index: Int) -> String {
        gamesCollection[index].genres?[index].name ?? ""
    }
    
    func getMetacritic( for index: Int) -> Int {
        gamesCollection[index].metacritic!
    }
    
    func getImage( for index: Int) -> String {
        guard let imageURL = gamesCollection[index].backgroundImage else { return "" }
        return imageURL
    }

}

