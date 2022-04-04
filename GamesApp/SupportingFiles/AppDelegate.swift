//
//  AppDelegate.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 30/03/2022.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
