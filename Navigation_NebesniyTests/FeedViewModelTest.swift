//
//  FeedViewModelTest.swift
//  Navigation_NebesniyTests
//
//  Created by Лёха Небесный on 23.05.2023.
//

import XCTest
import Foundation
@testable import Navigation_Nebesniy


class FeedViewModelTest: XCTestCase {

    var fakeFeedModel: FakeFeedModel?
    var fakeFeedCoordinator: FakeFeedCoordinator?
    var viewModel: FeedViewModel?

    override func setUpWithError() throws {
        self.fakeFeedModel = FakeFeedModel()
        self.fakeFeedCoordinator = FakeFeedCoordinator()

        self.viewModel = FeedViewModel(feedModel: self.fakeFeedModel!)
        self.viewModel?.coordinator = fakeFeedCoordinator
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateStateButtonDidTap() {
        self.viewModel?.updateState(viewInput: .buttonDidTap)

        XCTAssertTrue(self.fakeFeedCoordinator!.didPushPostViewController)
    }

    func testUpdateStateMusicButtonDidTap() {
        self.viewModel?.updateState(viewInput: .musicButtonDidTap)

        XCTAssertTrue(self.fakeFeedCoordinator!.didPushMusicViewController)
    }

    func testUpdateStateVideoButtonDidTap() {
        self.viewModel?.updateState(viewInput: .videoButtonDidTap)

        XCTAssertTrue(self.fakeFeedCoordinator!.didPushVideoViewController)
    }

    func testUpdateStateForCheckGuessButtonDidTapCheckWord(){

        let word = "Gnusmas"

        self.viewModel?.updateState(viewInput: .checkGuessButtonDidTap(word: word))

        XCTAssertEqual(word, self.fakeFeedModel?.checkWord)
    }

    func testUpdateStateForCheckGuessButtonDidTapCheckCorrectWord(){

        let word = "TestWord"

        self.viewModel?.updateState(viewInput: .checkGuessButtonDidTap(word: word))

        XCTAssertTrue(self.viewModel?.state == .correctly)
    }

    func testUpdateStateForCheckGuessButtonDidTapCheckNOTCorrectWord(){

        let word = "Gnusmas"

        self.viewModel?.updateState(viewInput: .checkGuessButtonDidTap(word: word))

        XCTAssertTrue(self.viewModel?.state == .wrong)
    }

}

class FakeFeedModel: FeedModelProtocol {
    var checkWord = ""

    func check(word: String) -> Bool {
        self.checkWord = word
        return word == "TestWord" ? true : false
    }

}

class FakeFeedCoordinator: FeedCoordinatorProtocol {

    var didPushPostViewController = false
    var didPushMusicViewController = false
    var didPushVideoViewController = false

    func pushPostViewController() {
        self.didPushPostViewController = true
    }

    func pushMusicViewController() {
        self.didPushMusicViewController = true
    }

    func pushVideoViewController() {
        self.didPushVideoViewController = true
    }
}
