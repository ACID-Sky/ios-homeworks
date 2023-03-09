//
//  Checker.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 03.02.2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth

enum FirebaseError: Error {
    case notAuthorized
    case isNotUser
    case invalidPassword
    case notEmail
    case custom(reason: String)
    case unknown
}

protocol CheckerServiceProtocol: AnyObject {
    var isAuthorized: Bool { get }

    func checkCredentials(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    )
    func signUp(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    )
}

final class Checker {

    static let shared: Checker = {
        let instance = Checker()
        return instance
    }()

    private init() {}

    private func responseHandler(
        _ response: (authData: AuthDataResult?, error: Error?),
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        let completionOnMainThread: (Result<UserModel, FirebaseError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        if let error = response.error {
            if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                completionOnMainThread(.failure(.isNotUser))
                return
            } else if error.localizedDescription == "The password is invalid or the user does not have a password." {
                completionOnMainThread(.failure(.invalidPassword))
                        return
            } else if error.localizedDescription == "The email address is badly formatted." {
                completionOnMainThread(.failure(.notEmail))
            } else {
                completionOnMainThread(.failure(.custom(reason: error.localizedDescription)))
                return
            }
        }

        guard
            let firUser = response.authData?.user
        else {
            completionOnMainThread(.failure(.notAuthorized))
            return
        }
        let user = UserModel(from: firUser)

        completionOnMainThread(.success(user))
    }
}

extension Checker: CheckerServiceProtocol {

    var isAuthorized: Bool {
        Auth.auth().currentUser != nil
    }

    func checkCredentials(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email,
                           password: password
        ) { [weak self] (authData, error) in
            self?.responseHandler(
                (authData: authData, error: error),
                completion: completion
            )
        }
    }

    func signUp(
        withEmail email: String,
        password: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email,
                               password: password
        ) { [weak self] (authData, error) in
            self?.responseHandler(
                (authData: authData, error: error),
                completion: completion
            )
        }

    }

    func signOut() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print("❌")
        }

    }

}

extension Checker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
}
    
}
