//
//  VideoTableViewCell.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 19.02.2023.
//

import UIKit
import AVFoundation
import AVKit
import YouTubeiOSPlayerHelper
//#import "YTPlayerView.h"

class VideoTableViewCell: UITableViewCell {

    private lazy var previewImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPreviewImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupPreviewImage() {
        previewImage.contentMode = .scaleToFill
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.clipsToBounds = true

        self.contentView.addSubview(previewImage)

        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
        let heightImage = 9 * UIScreen.main.bounds.width / 16
            NSLayoutConstraint.activate([
                self.previewImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.previewImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                self.previewImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                self.previewImage.heightAnchor.constraint(equalToConstant: heightImage),
                self.previewImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                self.previewImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        } else {
            let widhtImage = 16 * UIScreen.main.bounds.height / 9

            NSLayoutConstraint.activate([
                self.previewImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                self.previewImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                self.previewImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                self.previewImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
                self.previewImage.widthAnchor.constraint(equalToConstant: widhtImage),
                self.previewImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }

    }

    func setupCell( video: Video) {
        previewImage.image = video.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
