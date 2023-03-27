//
//  LoginModel.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 23.03.2023.
//

import Foundation

struct Login {
    var authorized: Bool
    var login: String
    var password: String

    init(authorized: Bool, login: String, password: String) {
        self.authorized = authorized
        self.login = login
        self.password = password
    }

    init(loginRealmModel: LoginRealmModel) {
        self.authorized = loginRealmModel.authorized
        self.login = loginRealmModel.login ?? ""
        self.password = loginRealmModel.password ?? ""
    }

    var keyedValues: [String: Any] {
        [
            "authorized": self.authorized,
            "login": self.login,
            "password": self.password
        ]
    }
}
