//
//  LikeCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 24.03.2023.
//

import UIKit

final class LikeCoordinator: ModuleCoordinatable {
    var moduleType: Module.ModuleType

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType) {
        self.moduleType = moduleType
    }

    func start() -> UIViewController {
        let likeController = LikeViewController()
        let likeViewController = UINavigationController(rootViewController: likeController)
        likeViewController.tabBarItem = moduleType.tabBarItem
        return likeViewController
    }
}
