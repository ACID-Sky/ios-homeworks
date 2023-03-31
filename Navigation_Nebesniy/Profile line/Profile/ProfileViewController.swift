//
//  ProfileViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit
import StorageService
import CoreData

class ProfileViewController: UIViewController {

    enum Constants {
        static let PhotoCellID = "PhotoCellID"
        static let defaultCellID = "DefaultCellID"
        static let PostCellID = "PostCellID"
        static let MyHeadView = "MyHeadView"

        static let numberOfPhoto: CGFloat = 4
        static let nemberOfPhotoCell: CGFloat = 10
        static let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let spacing: CGFloat = 8
    }

    let user: User?
    private var coreDataService: CoreDataService?

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

    lazy var fullScreenView: UIView = {
        let fullScreenView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        fullScreenView.alpha = 0
        fullScreenView.backgroundColor = .black
        fullScreenView.translatesAutoresizingMaskIntoConstraints = false
        return fullScreenView
    }()

    lazy var cancelButton: UIImageView = {
        let cancelButton = UIImageView()
        cancelButton.image = UIImage(systemName: "multiply")
        cancelButton.isUserInteractionEnabled = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.alpha = 0
        return cancelButton
    }()

    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreDataService = CoreDataServiceImp(delegate: self)
        self.view.backgroundColor = ConfigurationScheme.backgroundColor

        self.view.addSubview(tableView)
        self.view.addSubview(fullScreenView)
        self.fullScreenView.addSubview(cancelButton)
        self.setupGestures()


        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.fullScreenView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.fullScreenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.fullScreenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.fullScreenView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.cancelButton.topAnchor.constraint(equalTo: self.fullScreenView.safeAreaLayoutGuide.topAnchor),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.fullScreenView.trailingAnchor)
        ])
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.cancelButton.addGestureRecognizer(tapGestureRecognizer)

    }

    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.cancelButton.isUserInteractionEnabled = false

        let completion: () -> Void = { [weak self] in
            self?.cancelButton.isUserInteractionEnabled = true
        }

        self.animateKeyframes(completion: completion)
    }

    private func animateKeyframes(completion: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0.0,
                                options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1) {
                self.cancelButton.isUserInteractionEnabled = false
                self.fullScreenView.alpha = 0
                self.cancelButton.alpha = 0
                guard let header = self.tableView.headerView(forSection: 0) as? ProfileHeaderView else {
                    return
                }
                header.avatarTransform()
            }
        } completion: { _ in
            completion()
        }
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
            headrView.setupUser(user!)
            headrView.delegate = self
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
            let likedPosts = self.coreDataService?.getObjects()
            var likePost = false
            if likedPosts?.count != 0 {
                for (_, item) in likedPosts!.enumerated() where item.id == post.id {
                    likePost = true
                }
            }
            cell.setup(with: post, liked: likePost )
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = PhotosViewController()
        indexPath.section == 0 ? navigationController?.pushViewController(photo, animated: true) : nil
    }

}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func fullScreenChangeAlpha () {
        self.fullScreenView.alpha = 0.5
    }

    func cancelButtonChangeAlpha () {
        self.cancelButton.alpha = 1
        self.cancelButton.isUserInteractionEnabled = true
    }

    func logOut() {
        let alert = UIAlertController(title: "Выйти?", message: "Вы действительно хотите выйти?", preferredStyle: .alert)

        let yesAction = UIAlertAction(title: "LogOut", style: .destructive) { _ in
            let loginCoordinator = LoginCoordinator(moduleType: .login)
            let loginViewController = loginCoordinator.start()
            self.tabBarController?.viewControllers?[0] = loginViewController
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
    }   
}

extension ProfileViewController: PostTableViewCellDelegate {

    func likePost(post: Post, completion: @escaping (Bool) -> Void) {
        self.coreDataService?.createPost(post)
            completion(true)
    }

    func unLikePost(post: Post, completion: @escaping (Bool) -> Void) {
        let likedPosts = self.coreDataService?.getObjects()
        if likedPosts?.count != 0 {
            for (_, item) in likedPosts!.enumerated() where item.id == post.id {
                self.coreDataService?.deletePost(postModel: item)
            }
        }
            completion(true)
    }

    func ShowAlert(alert: AlertsMessage) {
        let alert = Alerts().showAlert(name: alert)
        self.present(alert, animated: true, completion: nil)

    }
}

extension ProfileViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
//            т.к. добавляю я посты только тут, то тут добавление обрабатывать не буду
            return

        case .delete:
            guard let likedPost = anObject as? LikePostCoreDataModel else { return }

            for (index, post) in posts.enumerated() where likedPost.id == post.id {
                self.tableView.reloadRows(at: [[1,index]], with: .fade)
            }
//            передвижения и обновления не предполагаются у меня, поэтому пока их не обрабатываю
        case .move:
            return
        case .update:
            return
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}


