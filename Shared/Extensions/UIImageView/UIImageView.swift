//
//  UIImageView.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit

public extension UIImageView {
    func setImage(url: String, placeHolder: UIImage) {
        let downloader = ImageDownloader()
        self.image = placeHolder
        guard let url = URL(string: url) else {
//            ImageLoaderError.urlNotCorrect
            return
        }
        downloader.loadImageData(url: url) { results in
            switch results {
            case .success(let imageData):
                guard let image = self.resize(imageData) else { return }
                self.image = UIImage(cgImage: image)
            case .failure:
                self.image = placeHolder
            }
        }
    }

    fileprivate func resize(_ imageData: Data) -> CGImage? {
        let image: CGImage?
        if self.bounds.size.equalTo(.zero) {
            let screenBounds = UIScreen.main.bounds
            image = ImageDataUtility.resize(data: imageData, for: CGSize(width: screenBounds.width, height: screenBounds.height))
        } else {
            image = ImageDataUtility.resize(data: imageData, for: CGSize(width: self.bounds.width, height: self.bounds.height))
        }
        return image
    }
}
