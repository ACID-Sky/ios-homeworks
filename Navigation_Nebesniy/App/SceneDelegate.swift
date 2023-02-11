//
//  SceneDelegate.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 26.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        let appCoordinator = AppCoordinator()
        self.appCoordinator = appCoordinator

        self.window?.rootViewController = appCoordinator.start()
        self.window?.makeKeyAndVisible()
    }
}

