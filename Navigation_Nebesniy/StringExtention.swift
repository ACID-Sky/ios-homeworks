//
//  StringExtention.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.03.2023.
//

import Foundation

extension String {

    func replace(_ pattern: String, replacement: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        return regex.stringByReplacingMatches(
            in: self,
            options: [.withTransparentBounds],
            range: NSRange(location: 0, length: self.count),
            withTemplate: replacement
        )
    }
}
