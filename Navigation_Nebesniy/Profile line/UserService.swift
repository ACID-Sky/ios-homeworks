//
//  CurrentUserService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 02.02.2023.
//

import Foundation
import UIKit

protocol UserService: AnyObject {
    func authorization(_ login: String) -> User?
}

final class CurrentUserService: UserService {

    private lazy var user: User = {
        let user = User(login: "ACID",
                        fullName: "Nebesnyi Aleksei",
                        status: "God please give me the strength to finish my day and hide the bodies of those that annoy me.",
                        avatarImage: UIImage(named: "Avatar"))
        return user
    }()
    
    func authorization(_ login: String) -> User? {
        login == user.login ? user : nil
    }
}

final class TestUserServic: UserService {

    private lazy var user: User = {
        let user = User(login: "ACID",
                        fullName: "Testerov Tester",
                        status: "I’m quite aware of my own inadequacies.",
                        avatarImage: UIImage(named: "images-6"))
        return user
    }()

    func authorization(_ login: String) -> User? {
        login == user.login ? user : nil
    }
}
