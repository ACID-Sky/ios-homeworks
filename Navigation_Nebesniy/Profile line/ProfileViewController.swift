//
//  ProfileViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    enum Constants {
        static let PhotoCellID = "PhotoCellID"
        static let defaultCellID = "DefaultCellID"
        static let PostCellID = "PostCellID"
        static let MyHeadView = "MyHeadView"

        static let numberOfPhoto: CGFloat = 4
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let spacing: CGFloat = 8
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.MyHeadView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: Constants.PhotoCellID)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.PostCellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return posts.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headrView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.MyHeadView) as? ProfileHeaderView else {
                return nil
            }
            return headrView
        }
        return nil

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PhotoCellID, for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PostCellID, for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
                return cell
            }
            let post = posts[indexPath.row]
            cell.setup(with: post)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = PhotosViewController()
        indexPath.section == 0 ? navigationController?.pushViewController(photo, animated: true) : nil
    }
}



