//
//  PhotosTableViewCell.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 12.01.2023.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {

    private lazy var photoCollection: [UIImage] = photos
    let notification = NotificationCenter.default

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.text = "Photos"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var arrowLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.text = "→"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = ProfileViewController.Constants.spacing
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ProfileViewController.Constants.defaultCellID)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: ProfileViewController.Constants.PhotoCellID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.contentView.backgroundColor = .white

        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(arrowLabel)
        self.contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),

            self.arrowLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.arrowLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),

            self.collectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -12),
            self.collectionView.heightAnchor.constraint(equalToConstant: 100)

        ])
    }

}

extension PhotosTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(ProfileViewController.Constants.nemberOfPhotoCell)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        for (index, photo) in photoCollection.enumerated() where indexPath.item == index {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewController.Constants.PhotoCellID, for: indexPath) as? PhotosCollectionViewCell else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewController.Constants.defaultCellID, for: indexPath)
                    return cell
                }
            do {
            try cell.setup(with: photo)
            cell.layer.cornerRadius = 6
            cell.clipsToBounds = true
            return cell
            } catch {
                switch error as? NavigationError {
                case .censuredImage:
                    self.photoCollection.remove(at: index)
                    self.notification.post(name: Notification.Name("CensuredImage"), object: nil)
                    self.collectionView.reloadData()
                case .undefined:
                    print("🎉 undefined")
                default:
                    print("🎉 default")
                }
            }
            }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileViewController.Constants.defaultCellID, for: indexPath)
        return cell
        }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - ProfileViewController.Constants.spacing * (ProfileViewController.Constants.numberOfPhoto - 1)
        let itemWidth = floor(width / ProfileViewController.Constants.numberOfPhoto)
        return CGSize(width: itemWidth, height: itemWidth)
    }

}
