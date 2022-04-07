//
//  FavoritesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit
import CoreData
import JGProgressHUD
import Nuke

class FavoritesViewController: UIViewController {
    
    @IBOutlet private weak var favoritesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: FavoritesViewModelProtocol?
    private let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavoritesViewModel(dataSource: FavoritesDataProvider(), statePresenter: self)
        viewModel?.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewLayout()
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - View setup methods:
private extension FavoritesViewController {
    func setupView() {
        registerCell()
        deviceIsRotated()
    }
    
    func registerCell() {
        favoritesCollectionView.register(cellClass: FavoritesCollectionViewCell.self)
    }
    
    func deviceIsRotated() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupCollectionViewLayout), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

// MARK: - State Presentable Protocol conformance:
extension FavoritesViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let message):
            activityIndicator(state: .loaded)
            show(message: message)
        case .loaded:
            favoritesCollectionView.reloadData()
            activityIndicator(state: .loaded)
        case .loading:
            activityIndicator(state: .loading)
        case .initial:
            activityIndicator(state: .loading)
        default:
            activityIndicator(state: .loaded)
        }
    }
    
    func activityIndicator(state: LoadingState) {
        switch state {
        case .loading:
//            activityIndicator.startAnimating()
            hud.show(in: view)
            favoritesCollectionView.isUserInteractionEnabled = false
        case .loaded:
//            activityIndicator.stopAnimating()
//            activityIndicator.removeFromSuperview()
            hud.dismiss(animated: true)
            favoritesCollectionView.isUserInteractionEnabled = true
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
    @objc func setupCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.orientation == .portrait {
            print("portrait")
            layout.itemSize = CGSize(width: view.frame.size.width/1, height: view.frame.size.height/5)
        } else {
            print("landscape")

            layout.itemSize = CGSize(width: view.frame.size.width/2.25, height: view.frame.size.height/3)
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

//MARK: - Setup image caching using Nuke:
private extension FavoritesViewController {
    func setupCaching() {
        DataLoader.sharedUrlCache.diskCapacity = 0
        let pipeline = ImagePipeline {
            let dataCache = try? DataCache(name: "rawg.io_CachedImages")
            dataCache?.sizeLimit = 200 * 1024 * 1024
            $0.dataCache = dataCache
        }
        ImagePipeline.shared = pipeline
    }
}
