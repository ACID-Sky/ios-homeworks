//
//  loginCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {

    private(set) var childCoordinators: [Coordinatable] = []

    func start() -> UIViewController {
        let loginController = LogInViewController(authorizationService: ConfigurationScheme.userService)
        loginController.loginDelegate = MyLoginFactory().makeLoginInspector()
        let loginViewController = UINavigationController(rootViewController: loginController)
        loginViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        return loginViewController
    }
}
