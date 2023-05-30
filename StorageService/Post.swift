//
//  Post.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 28.05.2022.
//

import UIKit

public struct Post {
    public let id: String
    public let author: String
    public let description: String
    public let image: UIImage
    public var likes: Int
    public var views: Int

    public init(author: String, description: String, image: UIImage, likes: Int, views: Int, id: String) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
        self.id = id
    }
}


