//
//  FeedModel.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 07.02.2023.
//

import Foundation

protocol FeedModelProtocol: AnyObject {
    func check(word: String) -> Bool
}

final class FeedModel: FeedModelProtocol {

    let secretWord = "Gnusmas"

    func check(word: String) -> Bool {
        if word == secretWord {
            return true
        } else{
            return false
        }
    }
}
