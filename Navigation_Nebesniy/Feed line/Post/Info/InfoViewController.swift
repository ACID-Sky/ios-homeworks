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

    private lazy var jsonTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemOrange
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray3
        self.view.addSubview(self.button)
        self.view.addSubview(self.jsonTitleLabel)
        loadJSON()

        self.jsonTitleLabel.layer.cornerRadius = 10
        self.jsonTitleLabel.layer.borderWidth = 0.5

        NSLayoutConstraint.activate([
            self.jsonTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.jsonTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.jsonTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.jsonTitleLabel.heightAnchor.constraint(equalToConstant: 80),
        ])


    }

    private func loadJSON () {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/5") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unwrappedData = data {

                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unwrappedData)

                        if let casted = dictionary as? [String: Any] {

                            if let userId = casted["userId"] as? Int,
                                let id = casted["id"] as? Int ,
                                let title = casted["title"] as? String ,
                                let completed = casted["completed"] as? Bool {
                                let jsonData = FirstJSONData(userId: userId, id: id, title: title, completed: completed)

                                DispatchQueue.main.async {
                                    self.jsonTitleLabel.text = jsonData.title
                                }
                            }
                        }

                    } catch let error {
                        print("😱", error)
                    }
                }
            }
            task.resume()
        }
    }

    @objc private func didTapButton() {
        let alert = UIAlertController(title: "Do you want to the Hell?",
                                      message: "If you really want to the Hell push 'Yes' else push 'No'.",
                                      preferredStyle: .actionSheet)

        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            print("User wants to the Hell!")
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)

    }

}
