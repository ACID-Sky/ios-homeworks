//
//  LogInViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 14.06.2022.
//

import UIKit

class LogInViewController: UIViewController {

    private let authorizationService: UserService
    var loginDelegate: LoginViewControllerDelegate?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var logoView: UIImageView = {
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.image = UIImage(named: "logo")
        logoImage.clipsToBounds = true
        return logoImage
    }()

    private lazy var bigStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var loginTextField: TextFieldWithPadding = {
        let login = TextFieldWithPadding()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.tag = 0
        login.backgroundColor = .systemGray6
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.keyboardType = .emailAddress
        login.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        login.delegate = self
        login.text = "acid_1@bk.ru"
        login.font = login.font?.withSize(15)
        return login
    }()

    private lazy var passwordTextField: TextFieldWithPadding = {
        let password = TextFieldWithPadding()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.tag = 1
        password.backgroundColor = .systemGray6
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        password.delegate = self
        password.text = "Qwerty"
        password.font = password.font?.withSize(15)
        return password
    }()

    private lazy var loginButton = CustomButton(title: "Login in",
                                                titleColor: .white,
                                                backgroundColor: UIColor(patternImage: UIImage(named: "blue_pixel")!),
                                                shadowRadius: 0,
                                                shadowOpacity: 0,
                                                shadowOffset: CGSize(width: 0, height: 0),
                                                action: { [weak self] in
                                                    self!.buttonPresed()
                                                })


    init(authorizationService: UserService) {
        self.authorizationService = authorizationService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        self.setupGestures()
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    private func setupView(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(logoView)
        self.scrollView.addSubview(bigStackView)
        self.bigStackView.addArrangedSubview(stackView)
        self.bigStackView.addArrangedSubview(loginButton)
        self.stackView.addArrangedSubview(loginTextField)
        self.stackView.addArrangedSubview(passwordTextField)

        let borderColor = UIColor.lightGray
        self.stackView.layer.cornerRadius = 10
        self.stackView.layer.borderWidth = 0.5
        self.stackView.layer.borderColor = borderColor.cgColor
        self.loginTextField.layer.borderWidth = 0.5
        self.loginTextField.layer.borderColor = borderColor.cgColor
        self.loginButton.layer.cornerRadius = 10


        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.logoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            self.logoView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoView.widthAnchor.constraint(equalToConstant: 100),
            self.logoView.heightAnchor.constraint(equalToConstant: 100),

            self.bigStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            self.bigStackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 120),
            self.bigStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            self.bigStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),

            self.stackView.heightAnchor.constraint(equalToConstant: 100),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Checker.shared.isAuthorized {
            if let user = self.authorizationService.authorization("acid_1@bk.ru") {
                // т.к. в этом задании мы данные пользователя не заносим в БД, то при удачной авторизации буду показывать имеющегося пользователя
                let profile = ProfileViewController(user: user)
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func signUp(login: String, password: String) {
        loginDelegate?.signUp(withEmail: login,
                              password: password) { result in
            switch result {
            case .success:
                self.openProfile()
            case .failure(let error):
                print("👎🏾", error)
            }
        }
    }

    private func showMailAllert() {
        let alert = UIAlertController(title: "Вы ввели не верный Login",
                                      message: "Поле Login должно быть заполнено e-mail (***@**.**).",
                                      preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func showIsNotUserAllert() {
        let alert = UIAlertController(title: "Пользователь с указанным e-mail не зарегистрирован!",
                                      message: "Пользователь не зарегистрирован или e-mail введен не корректно. Для регистрации пользователя нажмите 'SignUp'. Для редактирования e-mail нажмите 'Отмена'.",
                                      preferredStyle: .alert
        )

        let yesAction = UIAlertAction(title: "SignUp", style: .default) { _ in
            self.signUp(login: self.loginTextField.text ?? "", password: self.passwordTextField.text ?? "")
        }
        let noAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func showInvalidPasswordAllert() {
        let alert = UIAlertController(title: "Вы ввели не верный Password.",
                                      message: "Вы ввели не верный Password, попробуйте снова.",
                                      preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func openProfile(){
        if let user = self.authorizationService.authorization("acid_1@bk.ru") {
            // т.к. в этом задании мы данные пользователя не заносим в БД, то при удачной авторизации буду показывать имеющегося пользователя
            let profile = ProfileViewController(user: user)
            self.navigationController?.pushViewController(profile, animated: true)
        }
    }

    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let loginInButtonBottomPointY = self.bigStackView.frame.origin.y + self.loginButton.frame.origin.y + self.loginButton.frame.height

            let keyboardOriginY = self.scrollView.frame.origin.y + self.scrollView.frame.height - keyboardHeight

            let yOffset = keyboardOriginY < loginInButtonBottomPointY + 16
            ? loginInButtonBottomPointY - keyboardOriginY + 16
            : 0

            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }

    @objc private func buttonPresed () {
        loginDelegate?.check(login: loginTextField.text ?? "", password: passwordTextField.text ?? "") { result in
            switch result {
            case .success:
                    self.openProfile()
            case .failure(let error):
                switch error {
                case .notEmail:
                    self.showMailAllert()
                case .invalidPassword:
                    self.showInvalidPasswordAllert()
                case .isNotUser:
                    self.showIsNotUserAllert()
                case _:
                    print("☄️", error)
                }
            }
        }
//        passwordTextField.text = nil
    }

}

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.passwordTextField.becomeFirstResponder()
        } else {
            self.forcedHidingKeyboard()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

    }

}