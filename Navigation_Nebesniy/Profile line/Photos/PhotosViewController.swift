//
//  PhotosViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 15.01.2023.
//

import UIKit

class PhotosViewController: UIViewController {

    enum Constants {
        static let defaultCellID = "DefaultCellID"
        static let photoCellID = "PhotoCellID"

        static let numberOfColumns: CGFloat = 3
        static let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let spacing: CGFloat = 8
    }

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.spacing
        layout.minimumLineSpacing = Constants.spacing
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: Constants.photoCellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Photo Gallery"
        self.setupView()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        for (index, photo) in photos.enumerated() where indexPath.item == index {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoCellID, for: indexPath) as? PhotosCollectionViewCell else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
                    return cell
                }
                cell.setup(with: photo)
                cell.clipsToBounds = true
                return cell
            }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
        return cell
        }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interitemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? .zero
        let width = collectionView.frame.width - (Constants.numberOfColumns - 1) * interitemSpacing - sectionInset.left - sectionInset.right
        let itemWidth = floor(width / Constants.numberOfColumns)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
