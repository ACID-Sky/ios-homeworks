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
    private lazy var password: String = ""

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
            string: "Email or phone",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        login.delegate = self
        login.text = "ACID"
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

    private lazy var generationPasswordButton = CustomButton(title: "Generation password.",
                                                titleColor: .white,
                                                             backgroundColor: .systemGreen,
                                                shadowRadius: 0,
                                                shadowOpacity: 0,
                                                shadowOffset: CGSize(width: 0, height: 0),
                                                action: { [weak self] in
                                                    self!.generationPasswordButtonDidTap()
                                                })

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

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
        self.setupGenerationPasswordButton()
        self.setupActivityIndicator()
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

    private func setupGenerationPasswordButton() {
        self.view.addSubview(generationPasswordButton)
        self.generationPasswordButton.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            self.generationPasswordButton.topAnchor.constraint(equalTo: self.bigStackView.bottomAnchor, constant: 32),
            self.generationPasswordButton.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 16),
            self.generationPasswordButton.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -16),
            self.generationPasswordButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
//        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.passwordTextField.centerXAnchor),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 50),
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
        let aprovedUser = loginDelegate?.check(login: loginTextField.text ?? "", password: passwordTextField.text ?? "")
        if let user = authorizationService.authorization(aprovedUser ?? "") {
            let profile = ProfileViewController(user: user)
            self.navigationController?.pushViewController(profile, animated: true)
        }else {
            let alert = UIAlertController(title: "Вы ввели не верный Login или Password!", message: "Login или Password не соответствует нашим данным. Попробуйте еще раз.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
        }
        passwordTextField.text = nil
    }

    @objc private func generationPasswordButtonDidTap () {
        self.passwordTextField.isSecureTextEntry = true
        let allowCharacters: [String] = String().printable.map { String($0) }
        self.password = ""
        while self.password.count < 4 {
            let indexCharacter = Int.random(in: 0..<allowCharacters.count)
            self.password += allowCharacters[indexCharacter]
        }

        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()

        let brute = BruteForсe()
        DispatchQueue.global().async { [self] in
            let startTime = Date().timeIntervalSince1970
            brute.bruteForce(passwordToUnlock: self.password)
            print(Date().timeIntervalSince1970 - startTime)

            DispatchQueue.main.async {
                self.passwordTextField.text = self.password
                self.passwordTextField.isSecureTextEntry = false
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
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

