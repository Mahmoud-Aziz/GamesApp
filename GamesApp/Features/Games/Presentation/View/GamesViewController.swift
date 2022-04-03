//
//  GamesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 30/03/2022.
//

import UIKit

class GamesViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: CustomSearchBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: GamesViewModelProtocol?
    
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
//        registerFooter()
        deviceIsRotated()
        setupNavigationController()
        setupSearchBar()
    }
    
    func registerCell() {
        collectionView.register(cellClass: GamesCollectionViewCell.self)
    }
    
    func registerFooter() {
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
    }
    
    func setupNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupSearchBar() {
        self.searchBar.textDidChange = {[weak self] text in
            self?.viewModel?.search(with: text)
        }
    }
    
    func deviceIsRotated() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupCollectionViewLayout), name: UIDevice.orientationDidChangeNotification, object: nil)

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
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier, for: indexPath) as! FooterCollectionReusableView
//
//        footer.configure()
//
//        return footer
//    }
}

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
}

// MARK: - CollectionView delegate methods:
extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        highlightCell(cell: cell)
        viewModel?.didSelectItem(at: indexPath.row)
    }
    
    func highlightCell(cell: UICollectionViewCell?) {
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.gray.cgColor
    }
}

// MARK: - CollectionView layout methods:
extension GamesViewController {
     @objc func setupCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.orientation == .portrait {
            layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height/5)
        } else {
            layout.itemSize = CGSize(width: view.frame.size.width/2.25, height: view.frame.size.height/3)
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
            activityIndicator(state: .loaded)
            show(message: message)
        case .loaded:
            collectionView?.reloadData()
            activityIndicator(state: .loaded)
        case .loading:
            activityIndicator(state: .loading)
        case .initial:
            activityIndicator(state: .loading)
        case .navigate(let game):
            let route = GamesRoutes.gameDetails(game)
            navigate(to: route)
            
        }
    }
    
    func activityIndicator(state: LoadingState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            collectionView.isUserInteractionEnabled = false
        case .loaded:
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            collectionView.isUserInteractionEnabled = true
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
