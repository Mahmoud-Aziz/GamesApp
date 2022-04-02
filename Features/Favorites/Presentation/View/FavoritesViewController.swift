//
//  FavoritesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit
import CoreData
import JGProgressHUD

class FavoritesViewController: UIViewController {
    
    @IBOutlet private weak var favoritesCollectionView: UICollectionView!
    
    private let hud = JGProgressHUD()
    private var viewModel: FavoritesViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavoritesViewModel(dataSource: FavoritesDataProvider(), statePresenter: self)
        viewModel?.viewDidLoad()
        setupView()
    }
}

// MARK: - View setup methods:
extension FavoritesViewController {
    func setupView() {
        registerCell()
        setupCollectionViewLayout()
    }
    func registerCell() {
        favoritesCollectionView.register(cellClass: FavoritesCollectionViewCell.self)
    }
}

// MARK: - State Presentable Protocol conformance:
extension FavoritesViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let message):
            spinner(state: .loaded)
            show(message: message)
        case .loaded:
            favoritesCollectionView.reloadData()
            spinner(state: .loaded)
        case .loading:
            spinner(state: .loading)
        case .initial:
            spinner(state: .loading)
        default:
            spinner(state: .loaded)
        }
    }
    
    func spinner(state: LoadingState) {
        switch state {
        case .loading:
            hud.show(in: view)
        case .loaded:
            hud.dismiss()
        }
    }
    
    func show(message: String) {
        let alertController = UIAlertController(title: ViewError.alert.rawValue,
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CollectionView layout methods:
extension FavoritesViewController {
    func setupCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.orientation == .portrait {
            layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height/5)
        } else {
            layout.itemSize = CGSize(width: view.frame.size.width/1, height: view.frame.size.height/8)
        }
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        favoritesCollectionView!.collectionViewLayout = layout
    }
}

// MARK: - CollectionView data source methods:
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.game = viewModel?.getFavorite(at: indexPath.row)
        return cell
    }
}
