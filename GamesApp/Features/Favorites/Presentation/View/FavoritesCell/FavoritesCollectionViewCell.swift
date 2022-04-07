//
//  FavoritesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit
import Nuke

class FavoritesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var metacriticScoreLabel: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    
    private var task: ImageTask?
    
    var game: Favorite? {
        didSet {
            guard let game = game else { return }
            setupCell(game: game)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
    }
}

//MARK: - Cell data:
private extension FavoritesCollectionViewCell {
    func setupCell(game: Favorite) {
        gameTitleLabel.text = game.title
        setGenre(game: game)
        setMetacritic(game: game)
        setImage(game: game)
    }
    
    func setGenre(game: Favorite) {
        guard let genre = game.genre else {
            genreLabel.text = placeholder.genre.rawValue
            return
        }
        genreLabel.text = genre
    }
    
    func setMetacritic(game: Favorite) {
        guard let score = game.score else {
            metacriticScoreLabel.text = placeholder.score.rawValue
            return
        }
        metacriticScoreLabel.text = score
    }
    
    /// Setup image using Nuke's ImagePipeLine to load images in background thread.
    func setImage(game: Favorite) {
        guard let imageURL = URL(string: game.image ?? "") else { return }
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
        case image = "placeholder"
    }
}
