//
//  PhotosCollectionViewCell.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 15.01.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    lazy var picture: UIImageView = {
        let picture = UIImageView()
        picture.backgroundColor = .black
        picture.contentMode = .scaleAspectFill
        picture.image = UIImage(named: "")
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupContentView() {
        self.contentView.addSubview(self.picture)

        NSLayoutConstraint.activate([
            self.picture.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.picture.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.picture.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.picture.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    func setup(with namePhoto: String) {
        self.picture.image = UIImage(named: namePhoto)
    }
}

