//
//  FeedViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {

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
                                           shadowOffset: CGSize(width: 4, height: 4))
    
    private lazy var button2 = CustomButton(title: "To post too.",
                                            titleColor: .white,
                                            backgroundColor: .systemBlue,
                                            shadowRadius: 4.0,
                                            shadowOpacity: 0.7,
                                            shadowOffset: CGSize(width: 4, height: 4))

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
//        secretWord.delegate = self
        secretWord.text = "Gnusmas"
        secretWord.font = secretWord.font?.withSize(15)
        return secretWord
    }()

    private lazy var checkGuessButton = CustomButton(title: "Check text.",
                                                     titleColor: .white,
                                                     backgroundColor: .systemMint,
                                                     shadowRadius: 4.0,
                                                     shadowOpacity: 0.7,
                                                     shadowOffset: CGSize(width: 4, height: 4))

    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray2
        return label
    }()

    private let secretWorld: FeedModelProtocol

   
    init(secretWorld: FeedModelProtocol) {
        self.secretWorld = secretWorld
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .gray
        self.navigationItem.title = "Feed"
        setupView()
    }

    private func setupView() {
        self.view.addSubview(self.buttonVerticalStack)
        self.buttonVerticalStack.addArrangedSubview(self.button)
        self.buttonVerticalStack.addArrangedSubview(self.button2)
        self.view.addSubview(textField)
        self.view.addSubview(checkGuessButton)
        self.view.addSubview(answerLabel)

        let borderColor = UIColor.lightGray
        self.textField.layer.cornerRadius = 10
        self.textField.layer.borderWidth = 0.5
        self.textField.layer.borderColor = borderColor.cgColor
        self.checkGuessButton.layer.cornerRadius = 10
        self.checkGuessButton.layer.borderWidth = 0.5
        self.checkGuessButton.layer.borderColor = borderColor.cgColor

        button.tapAction = { [weak self] in
            self!.didTapButton()
        }
        button2.tapAction = { [weak self] in
            self!.didTapButton()
        }

        checkGuessButton.tapAction = { [weak self] in
            if ((self?.secretWorld.check(word: self?.textField.text ?? "_")) ?? false) {
                self?.answerLabel.backgroundColor = .systemGreen
            } else {
                self?.answerLabel.backgroundColor = .systemRed
            }
        }

        NSLayoutConstraint.activate([
            self.buttonVerticalStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.buttonVerticalStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.textField.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -16),
            self.textField.heightAnchor.constraint(equalToConstant: 40),

            self.checkGuessButton.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 16),
            self.checkGuessButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.checkGuessButton.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -16),
            self.checkGuessButton.heightAnchor.constraint(equalToConstant: 40),

            self.answerLabel.topAnchor.constraint(equalTo: self.checkGuessButton.bottomAnchor, constant: 16),
            self.answerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.answerLabel.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: -16),
            self.answerLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

        @objc private func didTapButton () {
            let postView = PostViewControlle ()
            postView.post = Post(author: "Hello World", description: "", image: "", likes: 2, views: 3)
            self.navigationController?.pushViewController(postView, animated: true)
        }

    }
