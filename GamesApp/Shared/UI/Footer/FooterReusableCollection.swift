//
//  FooterReusableCollection.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 07/04/2022.
//

import UIKit

let footerReuseIdentifier = "FooterReusableCollection"

class FooterReusableCollection: UICollectionReusableView {

    private let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
     }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

     }
    
    private func configure() {
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        addSubview(activityIndicator)
    }
}
