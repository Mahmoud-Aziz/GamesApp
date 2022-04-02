//
//  GamesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 30/03/2022.
//

import UIKit
import JGProgressHUD

class GamesViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: CustomSearchBar!
    private var viewModel: GamesViewModelProtocol?
    private let hud = JGProgressHUD()
    
    // MARK: - View life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GamesViewModel(dataSource: GamesDataProvider(), statePresenter: self)
        viewModel?.viewDidLoad()
        setupView()
    }
}
// MARK: - View setup methods:
private extension GamesViewController {
    func setupView() {
        registerCell()
        setupCollectionViewLayout()
        setupNavigationController()
        setupSearchBar()
    }
    
    func registerCell() {
        collectionView.register(cellClass: GamesCollectionViewCell.self)
    }
    
    func setupNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupSearchBar() {
        self.searchBar.textDidChange = {[weak self] text in
            self?.viewModel?.search(with: text)
        }
    }
}


// MARK: - CollectionView datasource methods:
extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GamesCollectionViewCell = collectionView.dequeue(for: indexPath)
        let game = viewModel?.getGames(at: indexPath.row)
        cell.game = game
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? 0
    }
}

// MARK: - CollectionView delegate methods:
extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionView layout methods:
extension GamesViewController {
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
        collectionView!.collectionViewLayout = layout
    }
}

// MARK: - State Presentable Protocol conformance:
extension GamesViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let message):
            spinner(state: .loaded)
            show(message: message)
        case .loaded:
            collectionView?.reloadData()
            spinner(state: .loaded)
        case .loading:
            spinner(state: .loading)
        case .initial:
            spinner(state: .loading)
        }
    }
    
    func spinner(state: EmptyState) {
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

// MARK: - ResuseIdentifiers:
private enum ResuseIdentifiers: String {
    case gamesCollectionViewCell = "GamesCollectionViewCell"
}
