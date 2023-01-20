//
//  ProfileHeaderView.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 05.06.2022.
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    private var statusText: String?
    private var isImageViewIncreased = false
    lazy var centerScreen = CGPoint(x: 0, y: 0)

    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.image = UIImage(named: "Avatar")
        avatarImage.clipsToBounds = true
        avatarImage.isUserInteractionEnabled = true
        return avatarImage
    }()

    private lazy var labelStack: UIStackView = {
        let screenWidth = UIScreen.main.bounds.width
        let labelStack = UIStackView()
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 10
        labelStack.distribution = .fillEqually
        return labelStack
    }()

    private lazy var fullNameLabel: UILabel = {
        let nick = UILabel()
        nick.font = UIFont.boldSystemFont(ofSize: 18)
        nick.textColor = UIColor.black
        nick.text = "ACID Sky"
        return nick
    }()

    fileprivate lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.font = status.font.withSize(14)
        status.textColor = UIColor.gray
        status.text = "I’m here."
        return status
    }()

    private lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.setTitle("Set status", for: .normal)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.addTarget(self, action:  #selector(buttonPresed), for: .touchUpInside)
        return button
    }()

    private lazy var statusTextField: TextFieldWithPadding = {
        let screenWidth = UIScreen.main.bounds.width
        let textField = TextFieldWithPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(
            string: "How are you?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.delegate = self
        textField.font = textField.font?.withSize(15)
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()

    let notification = NotificationCenter.default
    let ncObserver = NotificationCenter.default

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupGestures()
        ncObserver.addObserver(self, selector: #selector(self.changeAvatar), name: Notification.Name("AvatarChange"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(self.labelStack)
        self.labelStack.addArrangedSubview(self.fullNameLabel)
        self.labelStack.addArrangedSubview(self.statusLabel)
        self.addSubview(self.statusTextField)
        self.addSubview(self.setStatusButton)
        self.addSubview(self.avatarImageView)

        self.avatarImageView.layer.cornerRadius = 55
        self.avatarImageView.layer.borderWidth = 3
        self.setStatusButton.layer.cornerRadius = 4
        self.statusTextField.layer.cornerRadius = 12
        self.statusTextField.layer.borderWidth = 1

        NSLayoutConstraint.activate([
            self.avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 110),

            self.labelStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            self.labelStack.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 17),
            self.labelStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.labelStack.heightAnchor.constraint(equalToConstant: 81),

            self.setStatusButton.topAnchor.constraint(equalTo: self.statusTextField.bottomAnchor, constant: 10),
            self.setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            self.setStatusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),

            self.statusTextField.topAnchor.constraint(equalTo: self.labelStack.bottomAnchor, constant: 10),
            self.statusTextField.leadingAnchor.constraint(equalTo: self.labelStack.leadingAnchor),
            self.statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.statusTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func buttonPresed () {
        statusLabel.text = statusText
        statusTextField.text = nil
    }

    @objc private func statusTextChanged (_ textField: UITextField) {
        statusText = textField.text
    }

    func avatarTransform () {
        self.avatarImageView.center = CGPoint(x: 68, y: 68)
        self.avatarImageView.transform = .identity
        self.avatarImageView.layer.cornerRadius = 55
        self.avatarImageView.layer.borderWidth = 3
    }

    @objc func changeAvatar() {
        avatarTransform()
    }
    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.avatarImageView.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.avatarImageView.isUserInteractionEnabled = false

        let completion: () -> Void = { [weak self] in
            self?.avatarImageView.isUserInteractionEnabled = true
        }

        self.animateKeyframes(completion: completion)
    }

    private func animateKeyframes(completion: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: 0.8,
                                delay: 0.0,
                                options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 0.5/0.8) {
                //Не понимаю как отсюда достучаться до размеров и центра view на котором будет размещен tableView, создавать на фулскрин вью еще одну аваторку и её двигать, а эту прятать, мне кажется не правильным.
                self.avatarImageView.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width / self.avatarImageView.bounds.width, y: UIScreen.main.bounds.width / self.avatarImageView.bounds.width)
                self.avatarImageView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                self.avatarImageView.layer.cornerRadius = 0
                self.avatarImageView.layer.borderWidth = 0
                self.notification.post(name: Notification.Name("FullScreenViewChageAlpha"), object: nil)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5/0.8, // 1.25 sec.
                               relativeDuration: 0.3/0.8) {
                self.notification.post(name: Notification.Name("cancelButtonChangeAlpha"), object: nil)
            }
        } completion: { _ in
            completion()
        }
    }
}

extension ProfileHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
