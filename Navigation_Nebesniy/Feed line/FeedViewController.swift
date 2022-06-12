//
//  FeedViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

class FeedViewController: UIViewController {

        private lazy var button: UIButton = {
            let screenWidth = UIScreen.main.bounds.width
            let button = UIButton(frame: CGRect(x: 20, y: 220, width: screenWidth - 40, height: 50))
            button.backgroundColor = .systemRed
            button.setTitle("To post", for: .normal)
            button.addTarget(self, action:  #selector(didTapButton), for: .touchUpInside)
            return button
        }()
    

        override func viewDidLoad() {
            super.viewDidLoad()

            self.view.backgroundColor = .systemBrown
            self.navigationItem.title = "Feed"
            self.view.addSubview(self.button)
        }

        @objc private func didTapButton () {
            let postView = PostViewControlle ()
            postView.post = Post(title: "Hello World")
            self.navigationController?.pushViewController(postView, animated: true)
        }

    }
