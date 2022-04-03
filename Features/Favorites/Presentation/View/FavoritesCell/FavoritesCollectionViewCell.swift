//
//  FavoritesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var metacriticScoreLabel: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    
    var game: Favorite? {
        didSet {
            guard let game = game else { return }
            setupCell(game: game)
        }
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
    
    func setImage(game: Favorite) {
        guard let imageURL = game.image else { return }
        gameImageView.setImage(url: imageURL, placeHolder: Images.placeholder.image)
    }
    
    enum placeholder: String {
        case title = "No available name"
        case genre = "No available genre"
        case score = "No available score"
        case image = "placeholder"
    }
}
