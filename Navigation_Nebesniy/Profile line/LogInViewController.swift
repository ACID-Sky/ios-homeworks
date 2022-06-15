//
//  LogInViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 14.06.2022.
//

import UIKit

class LogInViewController: UIViewController {

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
            string: "Email or phone",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        login.delegate = self
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
        password.font = password.font?.withSize(15)
        return password
    }()

    private var login: String?
    private var password: String?

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(patternImage: UIImage(named: "blue_pixel")!)
        button.titleLabel?.textColor = .white
        button.setTitle("Login in", for: .normal)
        button.addTarget(self, action:  #selector(buttonPresed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(logoView)
        self.scrollView.addSubview(stackView)
        self.stackView.addArrangedSubview(loginTextField)
        self.stackView.addArrangedSubview(passwordTextField)
        self.scrollView.addSubview(loginButton)

        let borderColor = UIColor.lightGray
        self.stackView.layer.cornerRadius = 10
        self.stackView.layer.borderWidth = 0.5
        self.stackView.layer.borderColor = borderColor.cgColor
        self.loginTextField.layer.borderWidth = 0.5
        self.loginTextField.layer.borderColor = borderColor.cgColor
        self.loginButton.layer.cornerRadius = 10


        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.logoView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 120),
            self.logoView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoView.widthAnchor.constraint(equalToConstant: 100),
            self.logoView.heightAnchor.constraint(equalToConstant: 100),

            self.stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 120),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
            self.stackView.heightAnchor.constraint(equalToConstant: 100),

            self.loginButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.loginButton.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16),
            self.loginButton.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.loginButton.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            let loginInButtonBottomPointY = self.loginButton.frame.origin.y + self.loginButton.frame.height
            let keyboardOriginY = self.view.frame.height - keyboardHeight

            let yOffset = keyboardOriginY < loginInButtonBottomPointY + 32
            ? loginInButtonBottomPointY - keyboardOriginY + 32
            : 0

            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }

    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }

    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    @objc private func buttonPresed () {
        login = loginTextField.text
        password = passwordTextField.text
        loginTextField.text = nil
        passwordTextField.text = nil
        let profile = ProfileViewController ()
        self.navigationController?.pushViewController(profile, animated: true)
    }

}


extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            self.loginTextField.endEditing(true)
        } else if textField.tag == 1 {
            self.passwordTextField.endEditing(true)
        }
        self.forcedHidingKeyboard()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    func textFieldDidChangeSelection(_ textField: UITextField) {

    }

}

