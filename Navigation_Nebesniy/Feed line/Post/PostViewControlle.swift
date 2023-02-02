//
//  PostViewControlle.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit
import StorageService

class PostViewControlle: UIViewController {

    public var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        self.navigationItem.title = post?.author
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = barButton
    }

    @objc private func didTapButton () {
        let infoView = InfoViewController ()
        self.present(infoView, animated: true, completion: nil)
    }

}
