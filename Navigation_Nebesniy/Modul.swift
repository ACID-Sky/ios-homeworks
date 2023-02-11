//
//  Modul.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 09.02.2023.
//

import UIKit

protocol ViewModelProtocol: AnyObject {}

struct Module {
    enum ModuleType {
        case login
        case feed
    }

    let moduleType: ModuleType
    let viewModel: ViewModelProtocol
    let view: UIViewController
}

extension Module.ModuleType {
    var tabBarItem: UITabBarItem {
        switch self {
        case .login:
            return UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 0)
        case .feed:
            return UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 1)
        }
    }
}

