//
//  HeaderCollectionReusableView.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 03/04/2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "HeaderCollectionReusableView"
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    func configure() {
        addSubview(footerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        footerView.bounds = bounds
    }
}
