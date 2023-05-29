//
//  LogInViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 14.06.2022.
//

import UIKit

class LogInViewController: UIViewController {
    private let viewModel: LoginViewModelProtocol
    private lazy var loginView = LoginView(delegate: self)

    private let authorizationService: UserService

    init(authorizationService: UserService, viewModel: LoginViewModelProtocol) { 
        self.authorizationService = authorizationService
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        self.viewModel.updateState(viewInput: .checkAuthtorization)
        self.loginView.setupLogopas(for: self.viewModel.login) // поставил для удобства проверки
        self.bindViewModel()

    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                self.loginView.setupLogopas(for: self.viewModel.login)

            case .userIsAuthorized:
                DispatchQueue.main.async {
                    self.loginView.enableFaceIDButton()
                    let user = self.authorizationService.authorization("ACID")
                    let profile = ProfileViewController(user: user)
                    let item = self.tabBarController?.viewControllers?[0].tabBarItem
                    let profileController = UINavigationController(rootViewController: profile)
                    profileController.tabBarItem = item
                    self.tabBarController?.viewControllers?[0] = profileController
                }

            case .wrongPas:
                let alert = Alerts().showAlert(name: .wrongPas, handler: { _ in
                    self.viewModel.updateState(viewInput: .clearTextfield)
                })

                self.present(alert, animated: true, completion: nil)
            case .userNotCreated:
                let alert = Alerts().showAlert(name: .userNotCreated, handler: { _ in
                    self.viewModel.updateState(viewInput: .clearTextfield)
                })

                self.present(alert, animated: true, completion: nil)
            case .faceIDIsNotAvailable:
                let alert = Alerts().showAlert(name: .faceIDIsNotAvailable, handler: { _ in
                    self.viewModel.updateState(viewInput: .clearTextfield)
                })

                self.present(alert, animated: true, completion: nil)
            case .userForbidToUseFaceID:
                let alert = Alerts().showAlert(name: .userForbidToUseFaceID, handler: { _ in
                    self.viewModel.updateState(viewInput: .clearTextfield)
                })

                self.present(alert, animated: true, completion: nil)
            case .faceUnrecognized:
                self.loginView.disableFaceIDBotton()
                let alert = Alerts().showAlert(name: .faceUnrecognized)

                self.present(alert, animated: true, completion: nil)

            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension LogInViewController: LoginViewDelegate {
    func buttonPresed(with login: String, and password: String) {
        self.viewModel.updateState(viewInput: .checkLoginAndPassword(login: login, password: password))
    }

    func faceIDButtonPresed(){
        self.viewModel.updateState(viewInput: .checkFaceID)
    }
}
