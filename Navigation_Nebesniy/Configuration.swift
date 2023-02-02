//
//  Configuration.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 23.01.2023.
//

import UIKit

enum ConfigurationScheme {
    static var backgroundColor: UIColor? {
        #if DEBUG
        return .purple
        #else
        return .lightGray
        #endif

    }
}
