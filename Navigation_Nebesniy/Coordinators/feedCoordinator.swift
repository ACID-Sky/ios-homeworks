//
//  feedCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit

final class FeedCoordinator: Coordinatable {

    private(set) var childCoordinators: [Coordinatable] = []

    func start() -> UIViewController {
        let feedModel = FeedModel()
        let feedViewController = UINavigationController(rootViewController: FeedViewController(feedModel: feedModel))
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 1)
        return feedViewController
    }
}
