//
//  GamesViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 30/03/2022.
//

import UIKit

class GamesViewController: UIViewController {
    
    // MARK: - IBOutlets:
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchbar: UISearchBar!
    
    // MARK: - View life cycle methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - View setup methods:
    
    func setupView() {
        registerCell()
        setupCollectionViewLayout()
        setupNavigationController()
    }
    func registerCell() {
        let cell = UINib(nibName: ResuseIdentifiers.gamesCollectionViewCell.rawValue, bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: ResuseIdentifiers.gamesCollectionViewCell.rawValue)
    }
    
    func setupNavigationController() {
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CollectionView datasource methods:
extension GamesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResuseIdentifiers.gamesCollectionViewCell.rawValue, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    // MARK: - CollectionView delegate methods:
    
    // MARK: - CollectionView layout methods:
    func setupCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if UIDevice.current.orientation == .portrait {
            layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height/5)
        } else {
            layout.itemSize = CGSize(width: view.frame.size.width/1, height: view.frame.size.height/8)
        }
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
}

// MARK: - ResuseIdentifiers:
enum ResuseIdentifiers: String {
    case gamesCollectionViewCell = "GamesCollectionViewCell"
}
