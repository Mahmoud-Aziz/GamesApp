//
//  GamesRoutes.swift
//  GamesApp
//
//  Created by Mahmoud Aziz on 02/04/2022.
//

import UIKit

enum GamesRoutes: Route {
    case gameDetails(Response)

    var destination: UIViewController {
        switch self {
        case .gameDetails(let game):
            let detailsViewModel = DetailsViewModel(dataSource: DetailsDataProvider(id: game.id))
            let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
            return detailsViewController
        }
    }

    var style: NaivgationStyle {
        switch self {
        case .gameDetails:
            return .modal
        }
    }
}
