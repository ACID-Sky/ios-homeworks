//
//  FeedViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

class FeedViewController: UIViewController {

    private lazy var buttonVerticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        verticalStack.distribution = .equalCentering

        return verticalStack
    }()

        private lazy var button: UIButton = {
            let screenWidth = UIScreen.main.bounds.width
            let button = UIButton()
            button.backgroundColor = .systemGray
            button.setTitle("To post.", for: .normal)
            button.addTarget(self, action:  #selector(didTapButton), for: .touchUpInside)

            return button
        }()
    
    private lazy var button2: UIButton = {
        let screenWidth = UIScreen.main.bounds.width
        let button2 = UIButton()
        button2.backgroundColor = .systemBlue
        button2.setTitle("To post too.", for: .normal)
        button2.addTarget(self, action:  #selector(didTapButton), for: .touchUpInside)

        return button2
    }()

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.backgroundColor = .gray
            self.navigationItem.title = "Feed"
            self.view.addSubview(self.buttonVerticalStack)
            self.buttonVerticalStack.addArrangedSubview(self.button)
            self.buttonVerticalStack.addArrangedSubview(self.button2)

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
