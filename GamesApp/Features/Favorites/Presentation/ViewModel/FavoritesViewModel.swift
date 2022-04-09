//
//  FavoritesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

protocol FavoritesViewModelProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func getFavorite(at index: Int) -> Favorite
    func removeAtIndex(index: Int?)
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
    
    // MARK: - Use case execution:
    private func getFavorites() {
        dataSource.fetchFavorites(completion: { [weak self] result in
            switch result {
            case .success(let favorites):
                self?.favorites = favorites
                self?.state.render(state: .loaded)
            case .failure(let error):
                self?.state.render(state: .loaded)
                print("Error occured in getting favorites: \(error.localizedDescription)", logLevel: .error)
            }
        })
    }
}

// MARK: - FavoritesViewModel Protocol conformance:
extension FavoritesViewModel {
    func viewDidLoad() {
        state.render(state: .initial)
        getFavorites()
    }
    
    func viewWillAppear() {
        getFavorites()
    }
    
    func getFavorite(at index: Int) -> Favorite {
        guard let favorite = favorites?[safe: index] else {
            state.render(state: .empty)
            return Favorite()
        }
        state.render(state: .populated)
        return favorite
    }
    
    var numberOfItems: Int {
        guard let favorites = favorites?.count else {
            state.render(state: .empty)
            return 0
        }
        return favorites
    }
    
    func removeAtIndex(index: Int?) {
        guard let index = index else { return }
        guard let object = favorites?[index] else { return }
        dataSource.removeFavorite(object: object)
        favorites?.remove(at: index)
        
        if favorites?.count == 0 {
            state.render(state: .empty)
        }
    }
}
