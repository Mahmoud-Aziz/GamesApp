//
//  DetailsViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit
import JGProgressHUD
import CoreData

class DetailsViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var gameDescriptionLabel: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    
    private let viewModel: DetailsViewModelProtocol
    private let hud = JGProgressHUD()

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
        navigationController?.isNavigationBarHidden = false
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
        self.gameTitleLabel.text = viewModel.getTitle()
        self.gameDescriptionLabel.text = viewModel.getDescription()
        setupImageView()
        setupDescriptionLabel()
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
            spinner(state: .loaded)
            show(message: message)
        case .loaded:
            self.viewWillAppear(true)
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

// MARK: - IBAction methods:
extension DetailsViewController {
    @IBAction private func redditButtonTapped(_ sender: UIButton) {
        let url = viewModel.getReddit().toURL
        UIApplication.shared.open(url)
    }
    
    @IBAction private func websiteButtonTapped(_ sender: UIButton) {
        let url = viewModel.getWebsite().toURL
        UIApplication.shared.open(url)
    }
    
    @IBAction private func favoriteTapped(_ sender: UIButton) {
        let game = Game(context: CoreDataStack.shared.viewContext)
        game.title = viewModel.getTitle()
        game.reddit = viewModel.getReddit()
        game.website = viewModel.getWebsite()
        game.fullDescription = viewModel.getDescription()
        
        do {
            try CoreDataStack.shared.saveContext()
        }
        catch {
            //TODO: Log error
        }
    }
}
