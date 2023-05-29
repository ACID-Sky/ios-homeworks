//
//  feedCoordinator.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 08.02.2023.
//

import UIKit
import StorageService

protocol FeedCoordinatorProtocol: AnyObject {
    func pushPostViewController()
    func pushMusicViewController()
    func pushVideoViewController()
}

final class FeedCoordinator: ModuleCoordinatable, FeedCoordinatorProtocol {
    var moduleType: Module.ModuleType

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType) {
        self.moduleType = moduleType
    }

    func start() -> UIViewController {
        let feedModel = FeedModel()
        let viewModel = FeedViewModel(feedModel: feedModel)
        let feedViewController = UINavigationController(rootViewController: FeedViewController(viewModel: viewModel))
        feedViewController.tabBarItem = moduleType.tabBarItem
        let module = Module(moduleType: .feed, viewModel: viewModel, view: feedViewController)
        (module.viewModel as? FeedViewModel)?.coordinator = self
        self.module = module
        return feedViewController
    }

    func pushPostViewController() {
        let viewControllerToPush = PostViewController()
        viewControllerToPush.post = Post(author: "Hello World", description: "", image: UIImage(systemName: "display.2")!, likes: 2, views: 3, id: UUID().uuidString)
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)

    }

    func pushMusicViewController() {
        let viewControllerToPush = MusicViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)

    }

    func pushVideoViewController() {
        let viewControllerToPush = VideoViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)

    }
}
