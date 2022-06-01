//
//  InfoViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 28.05.2022.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var button: UIButton = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let button = UIButton(frame: CGRect(x: 20, y: screenHeight - 200, width: screenWidth - 40, height: 50))
        button.backgroundColor = .systemRed
        button.setTitle("To the Hell!", for: .normal)
        button.addTarget(self, action:  #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray3
        self.view.addSubview(self.button)

    }

    @objc private func didTapButton() {
        let alert = UIAlertController(title: "Do you want to the Hell?", message: "If you realy want to the Hell push 'Yes' else push 'No'.", preferredStyle: .actionSheet)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            print("User wants to the Hell!")
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)

    }

}
