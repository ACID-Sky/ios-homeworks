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

        let casesForAppConfiguration = [
            AppConfiguration.planets("https://swapi.dev/api/planets/"),
            AppConfiguration.starships("https://swapi.dev/api/vehicles/"),
            AppConfiguration.vehicles("https://swapi.dev/api/starships/")
            ]
        let appConfiguration: AppConfiguration = casesForAppConfiguration[Int.random(in: 0...casesForAppConfiguration.count)]

        NetworkService.request(for: appConfiguration)
    }
}

