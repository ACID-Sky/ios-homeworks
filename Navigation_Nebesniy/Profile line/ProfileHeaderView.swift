//
//  ProfileHeaderView.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 05.06.2022.
//

import UIKit

final class ProfileHeaderView: UIView {

    private lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImageView(frame: CGRect(x: 16, y: 16, width: 110, height: 110))
        avatarImage.image = UIImage(named: "Avatar")
        avatarImage.clipsToBounds = true
        return avatarImage
    }()

//    создаём аватарку

    private lazy var labelStack: UIStackView = {
        let screenWidth = UIScreen.main.bounds.width
        let labelStack = UIStackView(frame: CGRect(x: 71, y: 27, width: screenWidth - 87, height: 81))
        labelStack.axis = .vertical
        labelStack.spacing = 10
        labelStack.distribution = .fillEqually
        return labelStack
    }()
//    Создаём сток для леблов

    private lazy var nickLabel: UILabel = {
        let nick = UILabel()
        nick.font = UIFont.boldSystemFont(ofSize: 18)
        nick.textColor = UIColor.black
        nick.textAlignment = .center
        nick.text = "ACID Sky"

        return nick
    }()

    fileprivate lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.font = status.font.withSize(14)
        status.textColor = UIColor.gray
        status.textAlignment = .center
        status.text = "I’m quite aware of my own inadequacies."

        return status
    }()

    private lazy var showStatusButton: UIButton = {
        let screenWidth = UIScreen.main.bounds.width
        let button = UIButton(frame: CGRect(x: 16, y: 142, width: screenWidth - 32, height: 50))
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
//        button.setTitle("Show status", for: .normal)
//    Создаём лейблы ник и статус

        button.setTitle("Set status", for: .normal)
//        Новое название кнопки для задания со звёздочкой

        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
//        Тень

        button.addTarget(self, action:  #selector(buttonPresed), for: .touchUpInside)
//        Нажатие

        return button
    }()

    private lazy var textField: UITextField = {
        let screenWidth = UIScreen.main.bounds.width
        let textField = UITextField(frame: CGRect(x: 140, y: 100, width: screenWidth - 156, height: 40))
        textField.backgroundColor = .white
        textField.font = textField.font?.withSize(15)

        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)

        return textField
    }()
//    Создали текст фиелд для указания статуса

    private var statusText: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.height / 2
        self.avatarImageView.layer.borderWidth = 3

        self.showStatusButton.layer.cornerRadius = 4

        self.textField.layer.cornerRadius = 12
        self.textField.layer.borderWidth = 1

    }
// Обрезали аватарку, кнопку и тукст фиелд

    private func setupView() {
        self.addSubview(self.labelStack)
        self.labelStack.addArrangedSubview(self.nickLabel)
        self.labelStack.addArrangedSubview(self.statusLabel)
        self.addSubview(self.avatarImageView)
        self.addSubview(self.showStatusButton)
        self.addSubview(self.textField)

    }
// Добавили все элементы на вью

//    @objc private func buttonPresed () {
//        print(statusLabel.text as Any)
//    }
// Обрабатываем нажатие кнопки

    @objc private func buttonPresed () {
        statusLabel.text = statusText
    }
//    Изменили обработку нажатия кнопки на замену статуса

    @objc private func statusTextChanged (_ textField: UITextField) {
        statusText = textField.text
    }
//    обработка ввода статуса
}
