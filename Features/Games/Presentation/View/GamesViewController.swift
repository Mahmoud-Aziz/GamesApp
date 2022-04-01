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
    @IBOutlet private weak var searchbar: UISearchBar!
    private var viewModel: GamesViewModelProtocol?
    private let hud = JGProgressHUD()
    
    // MARK: - View life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GamesViewModel(dataSource: GamesDataProvider(), statePresenter: self)
        viewModel?.viewDidLoad()
        setupView()
    }
    
    // MARK: - View setup methods:
    
    func setupView() {
        registerCell()
        setupCollectionViewLayout()
        setupNavigationController()
    }
    func registerCell() {
        let cell = UINib(nibName: ResuseIdentifiers.gamesCollectionViewCell.rawValue, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: ResuseIdentifiers.gamesCollectionViewCell.rawValue)
    }
    
    func setupNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CollectionView datasource methods:
extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResuseIdentifiers.gamesCollectionViewCell.rawValue, for: indexPath) as! GamesCollectionViewCell
        guard let game = viewModel?.getGame(for: indexPath.row) else { return UICollectionViewCell() }
        cell.game = game
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItems ?? 0
    }
}

// MARK: - CollectionView delegate methods:

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
        case .error(let error):
            show(error: error)
            setEmptyView(state: .visible)
        case .loaded:
            collectionView?.reloadData()
            setEmptyView(state: .hidden)
        case .loading:
            setEmptyView(state: .visible)
        case .initial:
            setEmptyView(state: .visible)
        }
    }
    
    func setEmptyView(state: EmptyState) {
        switch state {
        case .visible:
            hud.show(in: view)
        case .hidden:
            hud.dismiss()
        }
    }
    
    func show(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: ViewError.operationFaield.rawValue,
                                                preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ResuseIdentifiers:
enum ResuseIdentifiers: String {
    case gamesCollectionViewCell = "GamesCollectionViewCell"
}

// MARK: - View Error:
enum ViewError: String {
    case operationFaield = "The operation couldn't be completed"
}
