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
            self.gameTitle.text = game?.name
            self.gameGenre.text = game?.genres?[0].name
            self.metacriticScore.text = game?.metacritic?.toString
            guard let imageURL = game?.backgroundImage else { return }
            self.gameImageView.setImage(url: imageURL, placeHolder: UIImage(named: "placeholder")!)
        }
    }
}
