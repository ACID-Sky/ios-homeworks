//
//  LikeViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 24.03.2023.
//

import UIKit
import StorageService
import CoreData

class LikeViewController: UIViewController {

    enum Constants {
        static let defaultCellID = "DefaultCellID"
        static let postCellID = "PostCellID"
    }

    private let coreDataService: CoreDataService = CoreDataServiceImp()
    private let realmService: RealmService = RealmServiceImp()
    private var login: Login?
    private var posts = [Post]()

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchLogin()
        self.fetchPost()
    }

    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postCellID)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupLabel(text: String) {
        self.view.backgroundColor = .systemBackground
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        self.label.font = UIFont.boldSystemFont(ofSize: 22)
        self.label.textColor = UIColor.systemBlue
        self.label.text = text

        self.view.addSubview(self.label)

        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            self.label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func fetchLogin() {
        let login = self.realmService.fetchLogin()

        if self.login != nil {
            guard login?.authorized != self.login?.authorized else {
                return
            }
            self.login = login
            guard let auth = login?.authorized, auth == true else {
                self.tableView.removeFromSuperview()
                self.setupLabel(text: "Вы не авторизованны! \nПерейдите на строницу 'Profile' и авторизуйтесь.")
                return
            }
            self.label.removeFromSuperview()
            self.setupTableView()

        } else {
            guard login?.authorized != self.login?.authorized else {
                self.setupLabel(text: "Вы не зарегистрированны! \nПерейдите на строницу 'Profile' и зарегистрируйтесь.")
                return
            }
            self.login = login
            guard let auth = login?.authorized, auth == true else {
                self.setupLabel(text: "Вы не авторизованны! \nПерейдите на строницу 'Profile' и авторизуйтесь.")
                return
            }
            self.setupTableView()
        }
    }

    private func fetchPost() {
        let posts = self.coreDataService.fetchPost()
        self.posts = posts.map {Post(author: $0.postAuthor ?? "",
                                     description: $0.postDescription ?? "",
                                     image: $0.postImage ?? "",
                                     likes: Int($0.postLikes),
                                     views: Int($0.postViews),
                                     id: $0.id ?? ""
        )}
        self.tableView.reloadData()
    }
}

extension LikeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellID, for: indexPath) as? PostTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }
        let post = self.posts[indexPath.row]
        cell.setup(with: post, liked: true)
        return cell
    }
}
