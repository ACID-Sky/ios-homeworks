//
//  PostViewControlle.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

class PostViewControlle: UIViewController {

    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGreen
        self.navigationItem.title = post?.title
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = barButton
    }

    @objc private func didTapButton () {
        let infoView = InfoViewController ()
        self.present(infoView, animated: true, completion: nil)
    }

}
