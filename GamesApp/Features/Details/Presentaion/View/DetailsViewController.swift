//
//  DetailsViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit
import CoreData
import Nuke

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameDescriptionLabel: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: DetailsViewModelProtocol
    
    // MARK: - Initilalizer:
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: DetailsViewController.nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(statePresenter: self)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
}

// MARK: - View setup methods:
private extension DetailsViewController {
    func setupView() {
        setupOutlets()
        setupFavoriteBarButton()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupOutlets() {
        setupImageView()
        gameTitleLabel.text = viewModel.getTitle()
        gameDescriptionLabel.text = viewModel.getDescription()
    }
    
    func setupFavoriteBarButton() {
        let favoriteBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteBarButtonTapped))
        self.navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    
    func setupImageView() {
        let url = viewModel.getImage()
        guard let url = URL(string: url) else { return }
        var resizedImageProcessors: [ImageProcessing] {
            let imageSize = gameImageView.frame.size
            return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
        }
        let request = ImageRequest(url: url, processors: resizedImageProcessors, cachePolicy: .default)
        Nuke.loadImage(with: request, into: gameImageView)
    }
}

// MARK: - State Presentable Protocol conformance:
extension DetailsViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let message):
            activityIndicator(state: .loaded)
            show(message: message)
        case .loaded:
            self.viewWillAppear(true)
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
            navigationItem.rightBarButtonItem?.isEnabled = false
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
            navigationItem.hidesBackButton = true
        case .loaded:
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
            navigationItem.hidesBackButton = false
            navigationItem.rightBarButtonItem?.isEnabled = true
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

// MARK: - IBAction methods:
private extension DetailsViewController {
    @IBAction func redditButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: viewModel.getReddit()) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: viewModel.getWebsite()) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func favoriteBarButtonTapped() {
        let favorite = Favorite(context: CoreDataStack.shared.viewContext)
        guard let title = viewModel.getTitle() else { return }
        favorite.title = title
        favorite.image = viewModel.getImage()
        favorite.score = viewModel.getScore()
        favorite.genre = viewModel.getGenre()
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            print("Error saving data to core data: \(error.localizedDescription)", logLevel: .error)
        }
    }
}

// MARK: - Setup image caching using Nuke:
private extension DetailsViewController {
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
