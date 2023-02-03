//
//  CurrentUserService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 02.02.2023.
//

import Foundation

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
