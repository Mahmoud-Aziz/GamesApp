//
//  FavoritesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit
import Nuke
import SwipeCellKit

class FavoritesCollectionViewCell: SwipeCollectionViewCell {
    @IBOutlet private weak var gameTitleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var metacriticScoreLabel: UILabel!
    @IBOutlet  weak var gameImageView: UIImageView!
    
    private var task: ImageTask?
    
    var game: Favorite? {
        didSet {
            guard let game = game else { return }
            setupCell(game: game)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gameImageView.image = nil
    }
}

// MARK: - Cell data:
private extension FavoritesCollectionViewCell {
    func setupCell(game: Favorite) {
        gameTitleLabel.text = game.title
        setGenre(game: game)
        setMetacritic(game: game)
        setImage(game: game)
    }
    
    func setGenre(game: Favorite) {
        guard let genre = game.genre else {
            genreLabel.text = Placeholder.genre.rawValue
            return
        }
        genreLabel.text = genre
    }
    
    func setMetacritic(game: Favorite) {
        guard let score = game.score else {
            metacriticScoreLabel.text = Placeholder.score.rawValue
            return
        }
        metacriticScoreLabel.text = score
    }
    
    /// Setup image using Nuke's ImagePipeLine to load images in background thread.
    func setImage(game: Favorite) {
        guard let imageURL = URL(string: game.image ?? "") else { return }
        Nuke.loadImage(with: imageURL, into: gameImageView)
    }
}
