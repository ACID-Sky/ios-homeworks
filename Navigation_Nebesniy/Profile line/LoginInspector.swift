//
//  LoginInspector.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 03.02.2023.
//

import Foundation
import UIKit

protocol LoginViewControllerDelegate {
    func check(login insertedLogin: String, password insertedPassword: String) -> String?
}

struct LoginInspector: LoginViewControllerDelegate {

    func check(login insertedLogin: String, password insertedPassword: String) -> String? {
        Checker.shared.check(login: insertedLogin, password: insertedPassword) ? insertedLogin : nil
    }

}
