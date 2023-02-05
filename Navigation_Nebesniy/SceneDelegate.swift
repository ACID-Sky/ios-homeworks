//
//  SceneDelegate.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 26.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)

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

        let tabBarController = UITabBarController()
        let loginController = LogInViewController(authorizationService: ConfigurationScheme.userService)
        loginController.loginDelegate = MyLoginFactory().makeLoginInspector()
        let loginViewController = UINavigationController(rootViewController: loginController)
        let feedViewController = UINavigationController(rootViewController: FeedViewController())

        tabBarController.viewControllers = [
            loginViewController,
            feedViewController
        ]

        loginViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 1)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

