//
//  FavoritesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

protocol FavoritesViewModelProtocol {
    func viewDidLoad()
    func getFavorite(at index: Int) -> Favorite
    var numberOfItems: Int { get }
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
    private let dataSource: FavouritesUseCase
    private let state: StatePresentable
    private var favorites: [Favorite]?
    
    init(dataSource: FavouritesUseCase, statePresenter: StatePresentable) {
        self.dataSource = dataSource
        self.state = statePresenter
    }
    
    //MARK: - Use case execution:
    
    func fetchFavorite() {
        dataSource.fetchFavorites(completion: { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.favorites = favorites
                self?.state.render(state: .loaded)
            case .failure(let error):
                self?.state.render(state: .loaded)
                //TODO: Log error 
            }
        })
    }
    
    func viewDidLoad() {
        state.render(state: .initial)
        fetchFavorite()
    }
    
    func getFavorite(at index: Int) -> Favorite {
        guard let favorite = favorites?[safe: index] else { return Favorite()}
        return favorite
    }
    
    var numberOfItems: Int {
        return favorites?.count ?? 0
    }
}
