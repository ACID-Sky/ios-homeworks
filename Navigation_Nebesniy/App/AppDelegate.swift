//
//  AppDelegate.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 26.05.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var container: NSPersistentContainer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.createContainer { container in
            self.container = container
        }

        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

    private func createContainer(completion: @escaping (NSPersistentContainer) -> Void) {
        let container = NSPersistentContainer(name: "Navigation_Nebesniy")
        container.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Failed to load store") }

            completion(container)
        }
    }
}

