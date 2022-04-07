//
//  TabBarViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gamesTab = GamesViewController()
        let favoritesTab = FavoritesViewController()
        
        let gamesTabItem = UITabBarItem(title: "Games", image: UIImage(named: "Games"), selectedImage: UIImage(named: "Games-Selected"))
        gamesTab.tabBarItem = gamesTabItem
        
        let favoritesTabItem = UITabBarItem(title: "Favorites", image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "Favorites-Selected"))
        favoritesTab.tabBarItem = favoritesTabItem
        
        let controllers = [gamesTab,favoritesTab]
        self.viewControllers = controllers
    }
}
