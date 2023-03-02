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

    private lazy var task1TitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Title from task 1."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var jsonTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var task2TitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.text = "Период обращения планеты Татуин вокруг своей звезды."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var jsonOrbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray3
        self.view.addSubview(self.button)
        self.view.addSubview(task1TitleLabel)
        self.view.addSubview(self.jsonTitleLabel)
        self.view.addSubview(task2TitleLabel)
        self.view.addSubview(jsonOrbitalPeriodLabel)
        loadJSON1()
        loadJSON2()

        self.jsonTitleLabel.layer.cornerRadius = 10
        self.jsonTitleLabel.layer.borderWidth = 0.5
        self.jsonOrbitalPeriodLabel.layer.cornerRadius = 10
        self.jsonOrbitalPeriodLabel.layer.borderWidth = 0.5

        NSLayoutConstraint.activate([
            self.task1TitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.task1TitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.task1TitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.task1TitleLabel.heightAnchor.constraint(equalToConstant: 40),

            self.jsonTitleLabel.topAnchor.constraint(equalTo: self.task1TitleLabel.bottomAnchor, constant: 16),
            self.jsonTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.jsonTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.jsonTitleLabel.heightAnchor.constraint(equalToConstant: 80),

            self.task2TitleLabel.topAnchor.constraint(equalTo: self.jsonTitleLabel.bottomAnchor, constant: 32),
            self.task2TitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.task2TitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.task2TitleLabel.heightAnchor.constraint(equalToConstant: 80),

            self.jsonOrbitalPeriodLabel.topAnchor.constraint(equalTo: self.task2TitleLabel.bottomAnchor, constant: 32),
            self.jsonOrbitalPeriodLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.jsonOrbitalPeriodLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.jsonOrbitalPeriodLabel.heightAnchor.constraint(equalToConstant: 80),
        ])


    }

    private func loadJSON1 () {
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
                                let user = UserJSONData(userId: userId, id: id, title: title, completed: completed)

                                DispatchQueue.main.async {
                                    self.jsonTitleLabel.text = user.title
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

    private func loadJSON2 () {
        if let url = URL(string: "https://swapi.dev/api/planets/1") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in

                if let unwrappedData = data {

                    do {
                        let planet = try JSONDecoder().decode(Planet.self, from: unwrappedData)
                        print("🌎", planet.orbitalPeriod)
//                        if let period = planet["orbitalPeriod"] {
                            DispatchQueue.main.async {
                                self.jsonOrbitalPeriodLabel.text = planet.orbitalPeriod
                            }
//                        }
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
