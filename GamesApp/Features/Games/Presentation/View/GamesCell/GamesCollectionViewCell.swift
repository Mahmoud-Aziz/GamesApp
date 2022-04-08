//
//  GamesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit
import Nuke
import SwipeCellKit

class GamesCollectionViewCell: SwipeCollectionViewCell {
    @IBOutlet private weak var gameTitle: UILabel!
    @IBOutlet private weak var gameGenre: UILabel!
    @IBOutlet private weak var metacriticScore: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    private var task: ImageTask?
    
    var game: Response? {
        didSet {
            guard let game = game else { return }
            setupCell(game: game)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Cancel task when cell is prepared for reuse to handle wrong images issue.
        task?.cancel()
    }
}

//MARK: - Setup cell data:
private extension GamesCollectionViewCell {
    func setupCell(game: Response) {
        gameTitle.text = game.name
        setGenre(game: game)
        setMetacritic(game: game)
        setImage(game: game)
    }
    
    func setGenre(game: Response) {
        guard let genre = game.genres?[safe: 0]?.name else {
            gameGenre.text = placeholder.genre.rawValue
            return
        }
        gameGenre.text = genre
    }
    
    func setMetacritic(game: Response) {
        guard let score = game.metacritic?.toString else {
            metacriticScore.text = placeholder.score.rawValue
            return
        }
        metacriticScore.text = score
    }
    
    /// Setup image using Nuke's ImagePipeLine to load images in background thread.
    func setImage(game: Response) {
        guard let imageURL = URL(string: game.backgroundImage ?? "") else { return }
        gameImageView.image = ImageLoadingOptions.shared.placeholder
        gameImageView.contentMode = .scaleAspectFit
        
        let task = ImagePipeline.shared.loadImage(with: imageURL) { [weak self] response in
            guard let self = self else {
                return
            }
            switch response {
            case .failure:
                self.gameImageView.image = ImageLoadingOptions.shared.failureImage
                self.gameImageView.contentMode = .scaleAspectFit
            case let .success(imageResponse):
                self.gameImageView.image = imageResponse.image
                self.gameImageView.contentMode = .scaleAspectFill
            }
        }
        self.task = task
    }
    
    enum placeholder: String {
        case title = "No available name"
        case genre = "No available genre"
        case score = "No available score"
    }
}
