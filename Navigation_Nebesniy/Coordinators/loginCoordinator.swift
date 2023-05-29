//
//  loginCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit


final class LoginCoordinator: ModuleCoordinatable{
    var moduleType: Module.ModuleType

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType) {
        self.moduleType = moduleType
    }

    func start() -> UIViewController {
        let realm = RealmServiceImp()
        let viewModel = LoginViewModel(realmServise: realm)
        let loginController = LogInViewController(authorizationService: ConfigurationScheme.userService, viewModel: viewModel)
        let loginViewController = UINavigationController(rootViewController: loginController)
        loginViewController.tabBarItem = moduleType.tabBarItem
        let module = Module(moduleType: .feed, viewModel: viewModel, view: loginViewController)
        self.module = module
        return loginViewController
    }
}
