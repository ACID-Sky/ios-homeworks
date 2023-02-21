//
//  FeedViewController.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.05.2022.
//

import UIKit

final class FeedViewController: UIViewController {

    private let viewModel: FeedViewModelProtocol

    private lazy var feedView = FeedView(delegate: self)

    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = feedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Feed"
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                self.feedView.answerLabel.backgroundColor = .systemGray2
            case .correctly:
                self.feedView.answerLabel.backgroundColor = .systemGreen
            case .wrong:
                self.feedView.answerLabel.backgroundColor =  .systemRed
            }
        }
    }
}


extension FeedViewController: FeedViewDelegate {
    func checkGuessButtonDidTap(word: String) {
        viewModel.updateState(viewInput: .checkGuessButtonDidTap(word: word))
    }

    func buttonDidTap() {
        viewModel.updateState(viewInput: .buttonDidTap)
    }

    func musicButtonDidTap() {
        viewModel.updateState(viewInput: .musicButtonDidTap)
    }

    func videoButtonDidTap() {
        viewModel.updateState(viewInput: .videoButtonDidTap)
    }
}
