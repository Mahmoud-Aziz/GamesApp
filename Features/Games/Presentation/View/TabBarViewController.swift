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
        let tabBar = UITabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        let gamesTabItem = UITabBarItem(title: TabBarItemTitle.games.rawValue, image: Images.games.image, selectedImage: Images.gamesSelected.image)
        let favoritesTabItem = UITabBarItem(title: TabBarItemTitle.favorites.rawValue, image: Images.favorites.image, selectedImage: Images.favoritesSelected.image)
        gamesTab.tabBarItem = gamesTabItem
        favoritesTab.tabBarItem = favoritesTabItem
        self.viewControllers = [gamesTab, favoritesTab]
    }

    enum TabBarItemTitle: String {
        case games = "Games"
        case favorites = "Favorites"
    }
}
