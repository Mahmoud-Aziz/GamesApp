//
//  TabBarViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 01/04/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gamesTab = GamesViewController()
        let favoritesTab = FavoritesViewController() 
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let tabBar = UITabBarController(nibName: "UITabBarController", bundle: nil)
        tabBar.modalPresentationStyle = .fullScreen
        let gamesTabItem = UITabBarItem(title: "Games", image: Images.games.image, selectedImage: Images.gamesSelected.image)
        let favoritesTabItem = UITabBarItem(title: "Favorites", image: Images.favorites.image, selectedImage: Images.favoritesSelected.image)
        gamesTab.tabBarItem = gamesTabItem
        favoritesTab.tabBarItem = favoritesTabItem
        self.viewControllers = [gamesTab, favoritesTab]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
