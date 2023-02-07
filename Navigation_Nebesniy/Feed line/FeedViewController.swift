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

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.backgroundColor = .gray
            self.navigationItem.title = "Feed"
            self.view.addSubview(self.buttonVerticalStack)
            self.buttonVerticalStack.addArrangedSubview(self.button)
            self.buttonVerticalStack.addArrangedSubview(self.button2)
            button.tapAction = { [weak self] in
                self!.didTapButton()
            }
            button2.tapAction = { [weak self] in
                self!.didTapButton()
            }

            NSLayoutConstraint.activate([
                self.buttonVerticalStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.buttonVerticalStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
        }

        @objc private func didTapButton () {
            let postView = PostViewControlle ()
            postView.post = Post(author: "Hello World", description: "", image: "", likes: 2, views: 3)
            self.navigationController?.pushViewController(postView, animated: true)
        }

    }
