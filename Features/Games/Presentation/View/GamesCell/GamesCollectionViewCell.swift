//
//  GamesCollectionViewCell.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var gameTitle: UILabel!
    @IBOutlet private weak var gameImageView: UIImageView!
    
    func setupCell(title: String, imageURL: String) {
        self.gameTitle.text = title
        self.gameImageView.setImage(url: imageURL, placeHolder: UIImage(named: "placeholder")!)
    }
}
