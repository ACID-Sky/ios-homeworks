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
                let user = authorizationService.authorization("ACID")
                let profile = ProfileViewController(user: user)
                let item = self.tabBarController?.viewControllers?[0].tabBarItem
                let profileController = UINavigationController(rootViewController: profile)
                profileController.tabBarItem = item
                self.tabBarController?.viewControllers?[0] = profileController

            case .wrongPas:
                let alert = UIAlertController(title: "Вы ввели не верный Login или Password!", message: "Login или Password не соответствует нашим данным. Попробуйте еще раз.", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.viewModel.updateState(viewInput: .clearTextfield)
                }

                alert.addAction(okAction)

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
}
