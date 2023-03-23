//
//  HabitRealmModel.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 23.03.2023.
//

import Foundation
import RealmSwift

final class LoginRealmModel: Object {
    @objc dynamic var authorized: Bool = false
    @objc dynamic var login: String?
    @objc dynamic var password: String?

    override class func primaryKey() -> String? {
        "login"
    }

    convenience init(login: Login) {
        self.init()
        self.authorized = login.authorized
        self.login = login.login
        self.password = login.password

    }
}
