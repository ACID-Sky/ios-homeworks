//
//  AppCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []

    func start() -> UIViewController {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .secondarySystemBackground
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .secondarySystemBackground
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            // Fallback on earlier versions
        }

        let loginCoordinator = LoginCoordinator(moduleType: .login)
        let feedCoordinator = FeedCoordinator(moduleType: .feed)

        let tabBarController = TabBarController(viewControllers: [
            loginCoordinator.start(),
            feedCoordinator.start()
        ])

        addChildCoordinator(loginCoordinator)
        addChildCoordinator(feedCoordinator)

        return tabBarController
    }

    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
