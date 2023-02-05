//
//  LoginFactory.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 04.02.2023.
//

import Foundation

protocol LoginFactory {
    func makeLoginInspector() -> LoginViewControllerDelegate
}

struct MyLoginFactory: LoginFactory {

    func makeLoginInspector() -> LoginViewControllerDelegate {
        return LoginInspector()
    }
}
