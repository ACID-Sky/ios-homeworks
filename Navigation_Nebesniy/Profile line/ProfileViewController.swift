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
//        profileHeaderView.backgroundColor = .systemGreen
        profileHeaderView.frame = CGRect(x: 0, y: 140, width: view.bounds.width, height: 300)

        return profileHeaderView
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.view.addSubview(self.profileHeaderView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true

    }

}
