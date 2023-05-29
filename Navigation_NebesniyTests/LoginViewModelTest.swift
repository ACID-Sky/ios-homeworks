//
//  LoginViewModelTest.swift
//  Navigation_NebesniyTests
//
//  Created by Лёха Небесный on 25.05.2023.
//

import XCTest
import Foundation
@testable import Navigation_Nebesniy

final class LoginViewModelTest: XCTestCase {
    enum State {
        case initial
        case userIsAuthorized
        case wrongPas
    }
    var realm: RealmService?
    var viewModel: LoginViewModel?

    override func setUpWithError() throws {
        self.realm = FakeRealm()
        self.viewModel = LoginViewModel(realmServise: self.realm!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateStateCheckAuthtorizationWithoutLoginInRealm() {
        self.viewModel?.updateState(viewInput: .checkAuthtorization)

        XCTAssertTrue(self.viewModel?.state == .initial)
    }

    func testUpdateStateCheckAuthtorizationWithNotAuthtorized() {
        (self.realm as! FakeRealm).login = Login(authorized: false, login: "Test", password: "Pass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)

        XCTAssertTrue(self.viewModel?.state == .initial)
    }

    func testUpdateStateCheckAuthtorizationWithAuthtorized() {
        (self.realm as! FakeRealm).login = Login(authorized: true, login: "Test", password: "Pass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)

        XCTAssertTrue(self.viewModel?.state == .userIsAuthorized)
    }

    func testCheckLoginAndPasswordWithoutLoginInRealm() {
        self.viewModel?.updateState(viewInput: .checkLoginAndPassword(login: "testUser", password: "testPass"))

        XCTAssertTrue(self.viewModel?.state == .userIsAuthorized &&
            (self.realm as! FakeRealm).login?.authorized == true &&
            (self.realm as! FakeRealm).login?.login == "testUser" &&
            (self.realm as! FakeRealm).login?.password == "testPass"
        )
    }

    func testCheckLoginAndPasswordWithWrongLogin() {
        (self.realm as! FakeRealm).login = Login(authorized: false, login: "Test", password: "testPass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)
        self.viewModel?.updateState(viewInput: .checkLoginAndPassword(login: "wrongLog", password: "testPass"))
        XCTAssertTrue(self.viewModel?.state == .wrongPas)
    }

    func testCheckLoginAndPasswordWithWrongPassword() {
        (self.realm as! FakeRealm).login = Login(authorized: false, login: "Test", password: "testPass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)
        self.viewModel?.updateState(viewInput: .checkLoginAndPassword(login: "Test", password: "wrongPass"))

        XCTAssertTrue(self.viewModel?.state == .wrongPas)
    }

    func testCheckLoginAndPasswordWithCorrectLoginAndPassword() {
        (self.realm as! FakeRealm).login = Login(authorized: true, login: "Test", password: "testPass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)
        self.viewModel?.updateState(viewInput: .checkLoginAndPassword(login: "Test", password: "testPass"))

        XCTAssertTrue(self.viewModel?.state == .userIsAuthorized)
    }

    func testClearTextfield() {
        (self.realm as! FakeRealm).login = Login(authorized: true, login: "Test", password: "testPass")
        self.viewModel?.updateState(viewInput: .checkAuthtorization)
        self.viewModel?.updateState(viewInput: .checkLoginAndPassword(login: "Test", password: "testPass"))
        
        self.viewModel?.updateState(viewInput: .clearTextfield)

        XCTAssertTrue(self.viewModel?.state == .initial)
    }

}

class FakeRealm: RealmService {
    var login: Login?

    func create(login: Navigation_Nebesniy.Login, update: Bool) -> Bool {
        self.login = login
        return true
    }

    func fetchLogin() -> Navigation_Nebesniy.Login? {
        return login
    }


}
