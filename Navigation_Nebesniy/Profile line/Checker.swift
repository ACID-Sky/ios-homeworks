//
//  Checker.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 03.02.2023.
//

import Foundation

class Checker {

    static let shared: Checker = {
        let instance = Checker()
        return instance
    }()

    private let login: String = "ACID"
    private let password: String = "Qwerty"

    private init() {}

    func check(login log: String, password pass: String) -> Bool {
        log == login && pass == password ? true : false
    }
}

extension Checker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
}
    
}
