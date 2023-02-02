//
//  PostTableViewCell.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 16.06.2022.
//

import UIKit
import StorageService
import iOSIntPackage

class PostTableViewCell: UITableViewCell {

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
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
        self.likesStackView.addArrangedSubview(viewsLabale)

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.titleLabel.topAnchor.constraint(equalTo: self.stackView.topAnchor),

            self.picture.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.picture.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.picture.heightAnchor.constraint(equalToConstant: self.contentView.frame.size.width),

            self.descriptionLabel.topAnchor.constraint(equalTo: self.picture.bottomAnchor, constant: 16),

            self.likesStackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.likesStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }

    func setup(with post: Post) {
        self.titleLabel.text = post.author
        let filter = ImageProcessor()
        filter.processImage(sourceImage: UIImage(named: "\(post.image)")!, filter: .bloom(intensity: 1.0)) {image in
            self.picture.image = image
        }
        self.descriptionLabel.text = post.description
        self.likesLabale.text = "Likes: \(post.likes)"
        self.viewsLabale.text = "Views: \(post.views)"
    }
}
