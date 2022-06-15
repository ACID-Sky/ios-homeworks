//
//  ProfileViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    private lazy var profileHeaderView: ProfileHeaderView = {
        let profileHeaderView = ProfileHeaderView()
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return profileHeaderView
    }()

    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "New Button."
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.view.addSubview(self.profileHeaderView)
        self.view.backgroundColor = .lightGray
        self.navigationItem.title = "Profile"
        self.view.addSubview(self.bottomButton)

        NSLayoutConstraint.activate([
            self.profileHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.profileHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.profileHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.profileHeaderView.heightAnchor.constraint(equalToConstant: 220),

            self.bottomButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.bottomButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

}
