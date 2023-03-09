//
//  LoginInspector.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 03.02.2023.
//

import Foundation
import UIKit

protocol LoginViewControllerDelegate {
    func check(login insertedLogin: String,
               password insertedPassword: String,
               completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    )

    func signUp(withEmail email: String,
                password: String,
                completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    )
}

struct LoginInspector: LoginViewControllerDelegate {

    func check(login insertedLogin: String,
               password insertedPassword: String,
               completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        Checker.shared.checkCredentials(withEmail: insertedLogin,
                                        password: insertedPassword,
                                        completion: completion
        )

    }

    func signUp(withEmail email: String,
                password: String,
                completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        Checker.shared.signUp(withEmail: email,
                              password: password,
                              completion: completion
        )
    }
}
