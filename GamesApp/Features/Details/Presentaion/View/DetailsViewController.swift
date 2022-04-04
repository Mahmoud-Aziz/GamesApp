//
//  DetailsViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit
import CoreData

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
}

// MARK: - View setup methods:
private extension DetailsViewController {
    func setupView() {
        gameTitleLabel.text = viewModel.getTitle()
        gameDescriptionLabel.text = viewModel.getDescription()
        setupImageView()
        setupFavoriteBarButton()
    }
    
    func setupFavoriteBarButton() {
        let favoriteBarButton = UIBarButtonItem(title: "Favorite",style: .plain, target: self, action: #selector(favoriteBarButtonTapped))
        self.navigationItem.rightBarButtonItem = favoriteBarButton
    }
    
    func setupImageView() {
        let url = viewModel.getImage()
        self.gameImageView.setImage(url: url, placeHolder: Images.placeholder.image)
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
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        case .loaded:
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
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

// MARK: - IBAction methods:
private extension DetailsViewController {
    @IBAction func redditButtonTapped(_ sender: UIButton) {
        let url = viewModel.getReddit().toURL
        UIApplication.shared.open(url)
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        let url = viewModel.getWebsite().toURL
        UIApplication.shared.open(url)
    }
    
    @objc func favoriteBarButtonTapped() {
        let favorite = Favorite(context: CoreDataStack.shared.viewContext)
        favorite.title = viewModel.getTitle()
        favorite.image = viewModel.getImage()
        favorite.score = viewModel.getScore()
        favorite.genre = viewModel.getGenre()
        do {
            try CoreDataStack.shared.saveContext()
        }
        catch {
            //TODO: Log error
        }
    }
}
