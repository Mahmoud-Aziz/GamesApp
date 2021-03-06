//
//  GamesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 30/03/2022.
//

import UIKit
import Nuke

class GamesViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: CustomSearchBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: GamesViewModelProtocol?
    private var footerActivityIndicator = UIActivityIndicatorView()

    // MARK: - View life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = GamesViewModel(dataSource: GamesDataProvider(), statePresenter: self)
        viewModel?.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - View setup methods:
private extension GamesViewController {
    func setupView() {
        registerCell()
        registerFooter()
        setupSearchBar()
        setupCaching()
        collectionView.keyboardDismissMode = .onDrag
    }
    
    func registerCell() {
        collectionView.register(cellClass: GamesCollectionViewCell.self)
    }
    
    func registerFooter() {
        collectionView.register(footer: CollectionViewFooterView.self)
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func setupSearchBar() {
        self.searchBar.textDidChange = {[weak self] text in
            if text.isEmpty {
                self?.viewModel?.stateDidChange(state: .notSearching)
                self?.collectionView.reloadData()
            }
            guard text.count >= 3 else { return }
            self?.viewModel?.search(with: text)
        }
    }
    
    func highlightCell(cell: UICollectionViewCell?) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.lightGray
        cell?.backgroundView = bgColorView
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

// MARK: - CollectionView scroll view delegate method:
extension GamesViewController {
    // Responsible for pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionView {
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
                viewModel?.loadMoreGames()
            }
        }
    }
}

// MARK: - CollectionView delegate methods:
extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        highlightCell(cell: cell)
        viewModel?.didSelectItem(at: indexPath.row)
    }
}

// MARK: - UICollectionReusableView Footer:
extension GamesViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewFooterView", for: indexPath)
            footerActivityIndicator.color = .red
            footer.addSubview(footerActivityIndicator)
            footerActivityIndicator.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 30)
            return footer
        }
        return UICollectionReusableView()
    }
    
    // Footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 30.0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout methods:
extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let columns: Int = {
            var count = 1
            if traitCollection.horizontalSizeClass == .regular {
                count = 2 } else if traitCollection.horizontalSizeClass == .compact { count = 1 }
            if collectionView.bounds.width > collectionView.bounds.height { count = 2 }
            return count
        }()
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(columns - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(columns))
        return CGSize(width: size, height: 180)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView?.collectionViewLayout.invalidateLayout()
        }, completion: nil)
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
        case .loadingMore:
            footerActivityIndicator.startAnimating()
            activityIndicator.stopAnimating()
        case .empty:
            collectionView.setEmptyView(title: "No results found!", image: .noResults)
        case .populated:
            collectionView.restore()
        }
    }
    
    func activityIndicator(state: LoadingState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        case .loaded:
            footerActivityIndicator.stopAnimating()
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
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

// MARK: - Setup image caching using Nuke:
private extension GamesViewController {
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
