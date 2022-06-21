//
//  ProfileHeaderView.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 05.06.2022.
//

import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {

    private var statusText: String?

    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.image = UIImage(named: "Avatar")
        avatarImage.clipsToBounds = true
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

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.addSubview(self.labelStack)
        self.labelStack.addArrangedSubview(self.fullNameLabel)
        self.labelStack.addArrangedSubview(self.statusLabel)
        self.addSubview(self.avatarImageView)
        self.addSubview(self.setStatusButton)
        self.addSubview(self.statusTextField)

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
}

extension ProfileHeaderView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
