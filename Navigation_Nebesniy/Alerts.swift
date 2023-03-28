//
//  Alerts.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 28.03.2023.
//

import Foundation
import UIKit

enum AlertsMessage: Error {
    case unLikeError
    case likeError

}

struct Alerts {

    func showAlert(name: AlertsMessage) -> UIAlertController {

        var title = ""
        var message = ""

        switch name {
        case .unLikeError:
            title = "Не удалось снять like."
            message = "Вовремя снятия like произошла ошибка. Попробуйте снова."
        case .likeError:
            title = "Не удалось поставить like."
            message = "Вовремя установки like произошла ошибка. Попробуйте снова."
        case _:
            title = "Ошибка."
            message = "Упс, что-то пошло не так"
        }

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert
        )



        let yesAction = UIAlertAction(title: "Ok", style: .default)

        alert.addAction(yesAction)

        return alert
    }
}
