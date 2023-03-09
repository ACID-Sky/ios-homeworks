//
//  ProfileViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit
import StorageService

protocol ProfileHeaderViewDelegate: AnyObject {
    func dismissView()
}

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

    let ncObserver = NotificationCenter.default
    let notification = NotificationCenter.default
    let user: UserVK?

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

    init(user: UserVK?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ConfigurationScheme.backgroundColor

        self.view.addSubview(tableView)
        self.view.addSubview(fullScreenView)
        self.fullScreenView.addSubview(cancelButton)
        self.setupGestures()

        ncObserver.addObserver(self, selector: #selector(self.changeFullScreen), name: Notification.Name("FullScreenViewChageAlpha"), object: nil)
        ncObserver.addObserver(self, selector: #selector(self.changeCancelButton), name: Notification.Name("cancelButtonChangeAlpha"), object: nil)

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

    func fullScreenChangeAlpha () {
        self.fullScreenView.alpha = 0.5
    }

    @objc func changeFullScreen() {
        self.fullScreenChangeAlpha()
    }

    func cancelButtonChangeAlpha () {
        self.cancelButton.alpha = 1
        self.cancelButton.isUserInteractionEnabled = true
    }

    @objc func changeCancelButton() {
        self.cancelButtonChangeAlpha()
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
                self.notification.post(name: Notification.Name("AvatarChange"), object: nil)
            }
        } completion: { _ in
            completion()
        }
    }
}
extension ProfileViewController: ProfileHeaderViewDelegate {
    func dismissView() {
        navigationController?.popToRootViewController(animated: true)
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
            cell.setup(with: post)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = PhotosViewController()
        indexPath.section == 0 ? navigationController?.pushViewController(photo, animated: true) : nil
    }

}



