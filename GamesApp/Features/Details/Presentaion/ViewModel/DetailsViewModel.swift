//
//  DetailsViewModel.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import Foundation

protocol DetailsViewModelProtocol {
    func getTitle() -> String?
    func getDetails()
    func viewDidLoad(statePresenter: StatePresentable)
    func getDescription() -> String
    func getReddit() -> String
    func getWebsite() -> String
    func getImage() -> String
    func getScore() -> String
    func getGenre() -> String
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    // MARK: - Private properties:
    private let dataSource: DetailsUseCase
    private var gameDetails: DetailsResponse?
    
    // MARK: - Public properties:
    var state: StatePresentable?
    
    // MARK: - Initializer:
    init(dataSource: DetailsUseCase) {
        self.dataSource = dataSource
    }
    
    // MARK: - Use case execution:
    func getDetails() {
        dataSource.getDetails(completion: { [weak self] result in
            switch result {
            case .success(let details):
                self?.gameDetails = details
                self?.state?.render(state: .loaded)
            case .failure(let error):
                self?.state?.render(state: .error(NetworkError.failedRequest.rawValue))
                print("Error occured in getting details: \(error.localizedDescription)", logLevel: .error)
            }
        })
    }
}

// MARK: - DetailsViewModelProtocol conformance:
extension DetailsViewModel {
    func viewDidLoad(statePresenter: StatePresentable) {
        self.state = statePresenter
        self.state?.render(state: .initial)
        getDetails()
    }
    
    func getTitle() -> String? {
        guard let title = gameDetails?.name else { return "-" }
        return title
    }
    
    func getDescription() -> String {
        guard let description = gameDetails?.description else { return "-" }
        let symbols = ["<p>": "", "</p>": "", "<br />": "", "<br>": "", "<strong>": "", "</strong>": ""]
        let clearDescription = symbols.reduce(description) { $0.replacingOccurrences(of: $1.key, with: $1.value) }
        return clearDescription
    }
    
    func getReddit() -> String {
        guard let reddit = gameDetails?.redditUrl else { return "-" }
        return reddit
    }
    
    func getWebsite() -> String {
        guard let website = gameDetails?.website else { return "-" }
        return website
    }
    
    func getImage() -> String {
        guard let image = gameDetails?.backgroundImage else { return ViewError.alert.rawValue }
        return image
    }
    
    // MARK: - Additional Coredata attributes:
    func getScore() -> String {
        guard let score = gameDetails?.metacritic else { return ViewError.alert.rawValue }
        return score.toString
    }
    
    func getGenre() -> String {
        guard let genre = gameDetails?.genres else { return ViewError.alert.rawValue }
        guard let genreName = genre[safe: 0]?.name else { return ViewError.alert.rawValue }
        return genreName
    }
}
