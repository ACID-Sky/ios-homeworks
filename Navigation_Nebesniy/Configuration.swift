//
//  Configuration.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 23.01.2023.
//

import UIKit

enum ConfigurationScheme {
    static var backgroundColor: UIColor {
        #if DEBUG
        return .purple
        #else
        return .lightGray
        #endif

    }

    static var userService: UserService {
        #if DEBUG
        return TestUserServic()
        #else
        return CurrentUserService()
        #endif
    }
}

enum AppConfiguration {
    case planets(String)
    case vehicles(String)
    case starships(String)
}
