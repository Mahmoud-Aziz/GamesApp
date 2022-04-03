//
//  GamesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var gameTitle: UILabel!
    @IBOutlet private weak var gameGenre: UILabel!
    @IBOutlet private weak var metacriticScore: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    
    var game: Response? {
        didSet {
            guard let game = game else { return }
            setupCell(game: game)
        }
    }
}

//MARK: - Cell data:
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
    
    func setImage(game: Response) {
        guard let imageURL = game.backgroundImage else { return }
        gameImageView.setImage(url: imageURL, placeHolder: Images.placeholder.image)
    }
    
    enum placeholder: String {
        case title = "No available name"
        case genre = "No available genre"
        case score = "No available score"
        case image = "placeholder"
    }
}
