//
//  TabBarViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gamesTab = GamesViewController()
        let favoritesTab = FavoritesViewController()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let tabBar = UITabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        
        let gamesTabItem = UITabBarItem(title: "Games", image: UIImage(named: "Games"), selectedImage: UIImage(named: "Games-Selected"))
        gamesTab.tabBarItem = gamesTabItem
        
        let favoritesTabItem = UITabBarItem(title: "Favorites", image: UIImage(named: "Favorites"), selectedImage: UIImage(named: "Favorites-Selected"))
        favoritesTab.tabBarItem = favoritesTabItem
        
        self.viewControllers = [gamesTab,favoritesTab]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
