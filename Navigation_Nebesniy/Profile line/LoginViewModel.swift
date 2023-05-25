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
    }

    enum ViewInput {
        case checkAuthtorization
        case checkLoginAndPassword(login: String, password: String)
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
                self.login?.authorized = true
                guard self.realmService.create(login: self.login!, update: true) else {
                    self.login?.authorized = false
                    return
                }
                self.state = .userIsAuthorized
            } else {
                self.state = .wrongPas
            }

        case .clearTextfield:
            self.state = .initial
        }
    }
}

