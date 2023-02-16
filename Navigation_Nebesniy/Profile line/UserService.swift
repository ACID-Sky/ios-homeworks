//
//  CurrentUserService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 02.02.2023.
//

import Foundation
import UIKit
// Чтобы в приложении осталось все варианты. Решил ошибку через Result оформить на примере логина.

protocol UserService: AnyObject {
    func authorization(_ login: String, completion: @escaping ((Result<User, Error>) -> Void))
}

final class CurrentUserService: UserService {

    private lazy var user: User = {
        let user = User(login: "ACId",
                        fullName: "Nebesnyi Aleksei",
                        status: "God please give me the strength to finish my day and hide the bodies of those that annoy me.",
                        avatarImage: UIImage(named: "Avatar"))
        return user
    }()

    func authorization(_ login: String, completion: @escaping ((Result<User, Error>) -> Void)) {
        login == user.login ? completion(.success(user)) : completion(.failure(NavigationError.undefined))
    }
}

final class TestUserServic: UserService {

    private lazy var user: User = {
        let user = User(login: "ACId",
                        fullName: "Testerov Tester",
                        status: "I’m quite aware of my own inadequacies.",
                        avatarImage: UIImage(named: "images-6"))
        return user
    }()

    func authorization(_ login: String, completion: @escaping ((Result<User, Error>) -> Void)) {
        login == user.login ? completion(.success(user)) : completion(.failure(NavigationError.undefined))
    }
}
