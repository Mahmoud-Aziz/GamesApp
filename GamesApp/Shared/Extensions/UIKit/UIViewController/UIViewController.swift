//
//  UIViewController.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit

extension UIViewController: NavigationRoute {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    func navigate(to route: Route) {
        switch route.style {
        case .modal:
            self.present(route.destination, animated: true, completion: nil)
        case .push:
            self.navigationController?.pushViewController(route.destination, animated: true)
        }
    }
}
