//
//  FeedView.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 10.02.2023.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func checkGuessButtonDidTap(word: String)
    func buttonDidTap()
    func musicButtonDidTap()
}

final class FeedView: UIView {

    private weak var delegate: FeedViewDelegate?

    private lazy var buttonVerticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        verticalStack.distribution = .equalCentering

        return verticalStack
    }()

    private lazy var button = CustomButton(title: "To post.",
                                           titleColor: .white,
                                           backgroundColor: .systemGray,
                                           shadowRadius: 4.0,
                                           shadowOpacity: 0.7,
                                           shadowOffset: CGSize(width: 4, height: 4),
                                           action: { [weak self] in
                                                self!.didTapButton()
                                            })

    private lazy var button2 = CustomButton(title: "To music.",
                                            titleColor: .white,
                                            backgroundColor: .systemBlue,
                                            shadowRadius: 4.0,
                                            shadowOpacity: 0.7,
                                            shadowOffset: CGSize(width: 4, height: 4),
                                            action: { [weak self] in
                                                self!.didTapMusicButton()
                                            })

    private lazy var button3 = CustomButton(title: "To video.",
                                            titleColor: .white,
                                            backgroundColor: .systemRed,
                                            shadowRadius: 4.0,
                                            shadowOpacity: 0.7,
                                            shadowOffset: CGSize(width: 4, height: 4),
                                            action: { [weak self] in
                                                self!.didTapButton()
                                            })


    private lazy var textField: UITextField = {
        let secretWord = UITextField()
        secretWord.translatesAutoresizingMaskIntoConstraints = false
        secretWord.tag = 1
        secretWord.backgroundColor = .systemGray6
        secretWord.textColor = .black
        secretWord.font = UIFont.systemFont(ofSize: 16)
        secretWord.autocapitalizationType = .none
        secretWord.attributedPlaceholder = NSAttributedString(
            string: "Enter secretWord",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        secretWord.delegate = self
        secretWord.text = "Gnusmas"
        secretWord.font = secretWord.font?.withSize(15)
        return secretWord
    }()

    private lazy var checkGuessButton = CustomButton(title: "Check text.",
                                                     titleColor: .white,
                                                     backgroundColor: .systemMint,
                                                     shadowRadius: 4.0,
                                                     shadowOpacity: 0.7,
                                                     shadowOffset: CGSize(width: 4, height: 4),
                                                     action: { [weak self] in
        self!.didTapCheckGuessButton(word: self?.textField.text ?? "_")
                                                        })

    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(delegate: FeedViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .gray
        addSubview(self.buttonVerticalStack)
        buttonVerticalStack.addArrangedSubview(self.button)
        buttonVerticalStack.addArrangedSubview(self.button2)
        buttonVerticalStack.addArrangedSubview(self.button3)
        addSubview(textField)
        addSubview(checkGuessButton)
        addSubview(answerLabel)
        setupGestures()

        let borderColor = UIColor.lightGray
        self.textField.layer.cornerRadius = 10
        self.textField.layer.borderWidth = 0.5
        self.textField.layer.borderColor = borderColor.cgColor
        self.checkGuessButton.layer.cornerRadius = 10
        self.checkGuessButton.layer.borderWidth = 0.5
        self.checkGuessButton.layer.borderColor = borderColor.cgColor

        NSLayoutConstraint.activate([
            self.buttonVerticalStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.buttonVerticalStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            self.textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            self.textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            self.textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.textField.heightAnchor.constraint(equalToConstant: 40),

            self.checkGuessButton.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 16),
            self.checkGuessButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            self.checkGuessButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.checkGuessButton.heightAnchor.constraint(equalToConstant: 40),

            self.answerLabel.topAnchor.constraint(equalTo: self.checkGuessButton.bottomAnchor, constant: 16),
            self.answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            self.answerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            self.answerLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        addGestureRecognizer(tapGesture)
    }

    @objc private func didTapButton () {
        delegate?.buttonDidTap()
    }

    @objc private func didTapMusicButton () {
        delegate?.musicButtonDidTap()
    }

    @objc private func forcedHidingKeyboard() {
        endEditing(true)
    }

    @objc private func didTapCheckGuessButton(word: String) {
        delegate?.checkGuessButtonDidTap(word: word)
    }

}

extension FeedView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.forcedHidingKeyboard()
        return true
    }

}

