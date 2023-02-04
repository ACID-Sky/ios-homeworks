//
//  User.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 02.02.2023.
//

import UIKit

final class User {

    let login: String
    let fullName: String
    let status: String
    let avatar: UIImage

    init(login: String, fullName: String, status: String, avatarImage: UIImage?) {
        self.login = login
        self.fullName = fullName
        self.status = status
        self.avatar = avatarImage ?? UIImage(systemName: "person.crop.circle")!
    }
}
