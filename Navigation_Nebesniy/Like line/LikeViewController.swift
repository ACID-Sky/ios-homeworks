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
    private var authorFilter: NSPredicate? = nil

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private lazy var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        let filterButton = UIBarButtonItem(barButtonSystemItem:  .search,
                                           target: self,
                                           action: #selector(addFilter)
        )
        let cancelFilterButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                 target: self,
                                                 action: #selector(deleteFilter)
        )
        self.navigationItem.rightBarButtonItems = [
            filterButton,
            cancelFilterButton
        ]
        self.navigationItem.rightBarButtonItems?[1].isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchLogin()
        self.fetchPost()
    }

    
    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

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
        self.coreDataService.fetchPost(predicate: self.authorFilter) {[weak self] posts in
            self?.posts = posts.map {Post(author: $0.postAuthor ?? "",
                                         description: $0.postDescription ?? "",
                                         image: $0.postImage ?? "",
                                         likes: Int($0.postLikes),
                                         views: Int($0.postViews),
                                         id: $0.id ?? ""
            )}
            self?.tableView.reloadData()
        }
    }

    @objc private func addFilter() {

        self.navigationItem.rightBarButtonItems?[0].isEnabled = false

        let alertController = UIAlertController(title: "Фильтр постов.",
                                                message: nil,
                                                preferredStyle: .alert)

        let createAction = UIAlertAction(title: "Filter", style: .default) { _ in

            if alertController.textFields?.first?.text?.count ?? 0 > 0 {

                self.authorFilter = NSPredicate(format: "%K CONTAINS %@",
                                                #keyPath(LikePostCoreDataModel.postAuthor),
                                                alertController.textFields?.first?.text ?? ""
                )
                self.fetchPost()
            self.navigationItem.rightBarButtonItems?[0].tintColor = .systemPurple

            self.navigationItem.rightBarButtonItems?[1].isEnabled = true
            }
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        }

        alertController.addTextField() {
            $0.placeholder = "Введите имя автора"
            $0.keyboardType = .asciiCapable
            $0.returnKeyType = .done
            $0.autocapitalizationType = .sentences
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)

        self.present(alertController, animated: true)
    }

    @objc private func deleteFilter() {
        self.navigationItem.rightBarButtonItems?[0].tintColor = .systemBlue
        self.navigationItem.rightBarButtonItems?[1].isEnabled = false
        self.authorFilter = nil
        self.fetchPost()
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

extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let post = self.posts[indexPath.row]
            self.coreDataService.deletePost(predicate: NSPredicate(format: "id == %@", post.id)) { [weak self] success in
                self?.posts.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .right)
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
