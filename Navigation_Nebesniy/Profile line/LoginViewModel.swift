//
//  LoginViewModel.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 24.05.2023.
//

import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    var login: Login? { get }
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {

    enum State {
        case initial
        case userIsAuthorized
        case wrongPas
        case userNotCreated
        case faceIDIsNotAvailable
        case faceUnrecognized
        case userForbidToUseFaceID
    }

    enum ViewInput {
        case checkAuthtorization
        case checkLoginAndPassword(login: String, password: String)
        case checkFaceID
        case clearTextfield
    }

    var onStateDidChange: ((State) -> Void)?


    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let realmService: RealmService
    var login: Login?

    init(realmServise: RealmService) {
        self.realmService = realmServise
    }

    private func authtorizationUser(){
        self.login?.authorized = true
        guard self.realmService.create(login: self.login!, update: true) else {
            self.login?.authorized = false
            return
        }
        self.state = .userIsAuthorized
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {

        case .checkAuthtorization:
            self.login = self.realmService.fetchLogin()
            guard let auth = self.login?.authorized, auth == true else { return }
            self.state = .userIsAuthorized

        case .checkLoginAndPassword(login: let enteredLogin, password: let enteredPassword):
            if self.login == nil {
                self.login = Login(authorized: false, login: enteredLogin, password: enteredPassword)

                guard self.realmService.create(login: self.login!, update: false) else {
                    self.login = nil
                    return
                }
            }
            if self.login?.login == enteredLogin && self.login?.password == enteredPassword {
                self.authtorizationUser()
            } else {
                self.state = .wrongPas
            }

        case .checkFaceID:
            self.login = self.realmService.fetchLogin()
            guard (self.login != nil) else {
                self.state = .userNotCreated
                return
            }
            let localAuthorizationService = LocalAuthorizationService()
            localAuthorizationService.authorizeIfPossible { result in
                switch result {
                case .success(let answer):
                    if answer {
                        self.authtorizationUser()
                    } else {
                        self.state = .faceUnrecognized
                    }
                case .failure(let error):
                    switch error {
                    case .faceIDIsNotAvailable:
                        self.state = .faceIDIsNotAvailable
                    case .faceUnrecognized:
                        self.state = .faceUnrecognized
                    case .userForbidToUseFaceID:
                        self.state = .userForbidToUseFaceID
                    }
                }

            }


        case .clearTextfield:
            self.state = .initial
        }
    }
}

