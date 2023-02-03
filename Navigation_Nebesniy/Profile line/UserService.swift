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

    let user = User()
    
    func authorization(_ login: String) -> User? {
        if login == user.login {
            return user
        }
        return nil
    }
}

final class TestUserServic: UserService {

    private lazy var user: User = {
        let user = User()
        user.login = "ACID"
        user.fullName = "Testerov Tester"
        user.status = "I’m quite aware of my own inadequacies."
        user.avatar = UIImage(named: "images-6")!
        return user
    }()

    func authorization(_ login: String) -> User? {
        if login == user.login {
            return user
        }
        return nil
    }
}
