//
//  FavoritesViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation
import UIKit
import CoreData

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
    
    func viewWillAppear() {
        fetchFavorite()
    }
    
    func getFavorite(at index: Int) -> Favorite {
        guard let favorite = favorites?[safe: index] else { return Favorite()}
        return favorite
    }
    
    var numberOfItems: Int {
        return favorites?.count ?? 0
    }
    
    func removeAtIndex(index: Int?) {
        guard let index = index else { return }
        favorites?.remove(at: index)
        guard let object = favorites?[index] as? NSManagedObject else { return }
        dataSource.removeFavorite(object: object)
    }
}
