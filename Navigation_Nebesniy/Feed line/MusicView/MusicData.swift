//
//  File.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 18.02.2023.
//

import UIKit

public struct Track {
    public let name: String
    public let image: UIImage
    public var text: String

    public init(name: String, image: UIImage, text: String) {
        self.name = name
        self.image = image
        self.text = text
    }
}

public let Music: [Track] = [
    Track(name: "Queen",
          image: UIImage(named: "queen")!,
          text: "Queen"),
    Track(name: "Noize_MC_-_Vsjo_kak_u_lyudejj",
          image: UIImage(named: "noize")!,
          text: "Noze MC - Всё как у людей"),
    Track(name: "maks_korzh_-_amsterdam",
          image: UIImage(named: "korj")!,
          text: "Макс Корж - Амстердам"),
    Track(name: "lone_-_ey_bro",
          image: UIImage(named: "leon")!,
          text: "L'one - Эй Бро"),
    Track(name: "Каста - Выходи Гулять",
          image: UIImage(named: "kasta")!,
          text: "Каста - Выходи гулять")
]
