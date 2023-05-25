//
//  VideoData.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 19.02.2023.
//

import Foundation
import UIKit

public struct Video {
    public let URLString: String
    public let image: UIImage

    public init(URLString: String, image: UIImage) {
        self.URLString = URLString
        self.image = image
    }
}

public let VideoList: [Video] = [
    Video(URLString: "https://www.youtube.com/watch?v=YIjzyl29Cw8",
          image: UIImage(named: "4689")!),
    Video(URLString: "https://www.youtube.com/watch?v=ROKGXp3zCEo",
          image: UIImage(named: "4690")!),
    Video(URLString: "https://www.youtube.com/watch?v=-kicGBIh5dw",
          image: UIImage(named: "4691")!),
    Video(URLString: "https://www.youtube.com/watch?v=-fuds_TJGqY",
          image: UIImage(named: "4692")!),
    Video(URLString: "https://www.youtube.com/watch?v=XbYcSIuUGqg",
          image: UIImage(named: "4693")!),
    Video(URLString: "https://www.youtube.com/watch?v=89UEbXg3yos&t=2221s",
          image: UIImage(named: "4694")!)
]


