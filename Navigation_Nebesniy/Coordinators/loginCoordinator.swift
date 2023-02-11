//
//  loginCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit

//final class LoginCoordinator: Coordinatable {
final class LoginCoordinator: ModuleCoordinatable {
    var moduleType: Module.ModuleType

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType) {
        self.moduleType = moduleType
    }

    func start() -> UIViewController {
        let loginController = LogInViewController(authorizationService: ConfigurationScheme.userService)
        loginController.loginDelegate = MyLoginFactory().makeLoginInspector()
        let loginViewController = UINavigationController(rootViewController: loginController)
        loginViewController.tabBarItem = moduleType.tabBarItem 
        return loginViewController
    }
}
