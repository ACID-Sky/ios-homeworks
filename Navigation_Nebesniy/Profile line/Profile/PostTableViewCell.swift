//
//  PostTableViewCell.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 16.06.2022.
//

import UIKit
import StorageService

protocol PostTableViewCellDelegate: AnyObject {
    func likePost(post: Post, completion: @escaping (Bool) -> Void)
    func unLikePost(post: Post, completion: @escaping (Bool) -> Void)
    func ShowAlert(alert: AlertsMessage)
}

class PostTableViewCell: UITableViewCell {

    weak var delegate: PostTableViewCellDelegate?
    private var post: Post?
    private lazy var like = false

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var picture: UIImageView = {
        let picture = UIImageView()
        picture.backgroundColor = .black
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var likesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var likesLabale: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var viewsLabale: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var likeImage: UIImageView = {
        let picture = UIImageView()
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.likesLabale.text = nil
        self.viewsLabale.text = nil
        self.picture.image = nil
    }

    private func setupView() {
        self.contentView.backgroundColor = .white

        self.contentView.addSubview(stackView)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(picture)
        self.stackView.addArrangedSubview(descriptionLabel)
        self.stackView.addArrangedSubview(likesStackView)
        self.likesStackView.addArrangedSubview(likesLabale)
        self.likesStackView.addArrangedSubview(likeImage)
        self.likesStackView.addArrangedSubview(viewsLabale)

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.stackView.topAnchor),

            self.picture.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.picture.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.picture.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.picture.heightAnchor.constraint(equalToConstant: self.contentView.frame.size.width),

            self.descriptionLabel.topAnchor.constraint(equalTo: self.picture.bottomAnchor, constant: 16),

            self.likesStackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.likesStackView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: -16),
            self.likesStackView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.likesStackView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),

            self.likesLabale.leadingAnchor.constraint(equalTo: self.likesStackView.leadingAnchor),
            self.likesLabale.widthAnchor.constraint(equalToConstant: 80),
            self.likeImage.leadingAnchor.constraint(equalTo: self.likesLabale.trailingAnchor),
            self.viewsLabale.trailingAnchor.constraint(equalTo: self.likesStackView.trailingAnchor),
            self.viewsLabale.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func setup(with post: Post, liked like: Bool) {
        self.post = post
        self.titleLabel.text = post.author
        self.picture.image = post.image
        self.descriptionLabel.text = post.description
        self.likesLabale.text = "Likes: \(post.likes)"
        self.viewsLabale.text = "Views: \(post.views)"

        self.changeLiked(like: like)
    }

    private func changeLiked(like: Bool) {
        self.like = like
        guard like else {
            self.likeImage.tintColor = .systemGray
            self.likeImage.image = UIImage(systemName: "heart")
            return
        }
        self.likeImage.tintColor = .systemRed
        self.likeImage.image = UIImage(systemName: "heart.fill")
    }

    private func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.likePost(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func likePost(_ gestureRecognizer: UITapGestureRecognizer){
        guard let post = self.post else {
            return
        }
        self.contentView.isUserInteractionEnabled = false
        if self.like {
            self.delegate?.unLikePost(post: post) {[weak self] success in
                if success != true {
                    self?.changeLiked(like: false)
                    self?.delegate?.ShowAlert(alert: .unLikeError)
                }
            }
//            Перенес отображения UI из коплишена для более быстрой обработки, в комплишине обработал ошибку, если не удалось success false или ошибка.
            self.changeLiked(like: false)
        } else {
            self.delegate?.likePost(post: post) {[weak self] success in
                if success != true {
                    self?.changeLiked(like: true)
                    self?.delegate?.ShowAlert(alert: .likeError)
                }
            }
//            Перенес отображения UI из коплишена для более быстрой обработки, в комплишине обработал ошибку, если не удалось success false или ошибка.
            self.changeLiked(like: true)
        }
        self.contentView.isUserInteractionEnabled = true
    }
}

extension PostTableViewCell {
    func picupItems() -> Post? {
        return self.post
    }
}
