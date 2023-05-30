//
//  LoginView.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 25.05.2023.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func buttonPresed(with login: String, and password: String)
    func faceIDButtonPresed()
}

class LoginView: UIView {

    private weak var delegate: LoginViewDelegate?

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
            string: "Email or Nick",
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

    private lazy var loginButton = CustomButton(title: "Login in",
                                                titleColor: .white,
                                                backgroundColor: .systemGray,
                                                shadowRadius: 0,
                                                shadowOpacity: 0,
                                                shadowOffset: CGSize(width: 0, height: 0),
                                                action: { [weak self] in
                                                    self!.buttonPresed()
                                                })

    private lazy var faceIDButton = CustomButton(title: "Login by FaceID",
                                                titleColor: .white,
                                                backgroundColor: UIColor(patternImage: UIImage(named: "blue_pixel")!),
                                                shadowRadius: 0,
                                                shadowOpacity: 0,
                                                shadowOffset: CGSize(width: 0, height: 0),
                                                action: { [weak self] in
                                                    self!.faceIDButtonPresed()
                                                })

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.addGestureRecognizer(tapGesture)
    }

    init(delegate: LoginViewDelegate){
        super.init(frame: .zero)
        self.delegate = delegate
        self.backgroundColor = .white
        self.subscribeToNotification()
        self.setupView()
        self.setupGestures()
        self.checkCharacters()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setupView(){
        self.addSubview(scrollView)
        self.scrollView.addSubview(logoView)
        self.scrollView.addSubview(bigStackView)
        self.bigStackView.addArrangedSubview(stackView)
        self.bigStackView.addArrangedSubview(loginButton)
        self.bigStackView.addArrangedSubview(faceIDButton)
        self.stackView.addArrangedSubview(loginTextField)
        self.stackView.addArrangedSubview(passwordTextField)

        let borderColor = UIColor.lightGray
        self.stackView.layer.cornerRadius = 10
        self.stackView.layer.borderWidth = 0.5
        self.stackView.layer.borderColor = borderColor.cgColor
        self.loginTextField.layer.borderWidth = 0.5
        self.loginTextField.layer.borderColor = borderColor.cgColor
        self.loginButton.layer.cornerRadius = 10
        self.faceIDButton.layer.cornerRadius = 10


        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

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

    private func checkCharacters() {
        guard let countOfCharacterPass = self.passwordTextField.text?.count,
              countOfCharacterPass >= 4,
              let countOfCharacterLog = self.loginTextField.text?.count,
              countOfCharacterLog >= 4 else {
            self.loginButton.backgroundColor = .systemGray
            self.loginButton.isUserInteractionEnabled = false
            return
        }
        self.loginButton.backgroundColor = UIColor(patternImage: UIImage(named: "blue_pixel")!)
        self.loginButton.isUserInteractionEnabled = true
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
        self.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }

    /// Проверить логин - открыть слуд окно, создать логин и пароль или показать ошибку
    @objc private func buttonPresed () {
        guard let log = self.loginTextField.text, let pass = self.passwordTextField.text else {
            return
        }
        self.delegate?.buttonPresed(with: log, and: pass)
        passwordTextField.text = nil
    }

    /// Проверяем возможность войти по биметрии
    @objc private func faceIDButtonPresed() {
        self.delegate?.faceIDButtonPresed()
    }

    /// Функция для удобства проверки (что бы не запоминать логин и пароль)
    /// - Parameter login: экземляр Login (логин, пароль, авторизован или нет)
    func setupLogopas(for login: Login?) {
        guard let user = login else {
            self.loginTextField.text = nil
            self.passwordTextField.text = nil
            return
        }
        self.loginTextField.text = user.login
        self.passwordTextField.text = user.password
    }
}

extension LoginView {
    func disableFaceIDBotton(){
        self.faceIDButton.isUserInteractionEnabled = false
        self.faceIDButton.backgroundColor = .systemGray
    }

    func enableFaceIDButton(){
        self.faceIDButton.backgroundColor = UIColor(patternImage: UIImage(named: "blue_pixel")!)
        self.faceIDButton.isUserInteractionEnabled = true
    }
}

extension LoginView: UITextFieldDelegate {

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
        self.checkCharacters()
    }

}
