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
    case wrongPas
    case userNotCreated
    case faceIDIsNotAvailable
    case faceUnrecognized
    case userForbidToUseFaceID
}

struct Alerts {

    func showAlert(name: AlertsMessage, handler:((UIAlertAction) -> Void)?) -> UIAlertController {

        var title = ""
        var message = ""

        switch name {
        case .unLikeError:
            title = "Не удалось снять like."
            message = "Вовремя снятия like произошла ошибка. Попробуйте снова."
        case .likeError:
            title = "Не удалось поставить like."
            message = "Вовремя установки like произошла ошибка. Попробуйте снова."
        case .wrongPas:
        title = "Вы ввели не верный Login или Password!"
        message = "Login или Password не соответствует нашим данным. Попробуйте еще раз."
        case .userNotCreated:
        title = "Пользователь не создан"
        message = "Мы ни чего не знаем о пользователе. Введите Login, Password и нажмите кнопку LogIn для создания пользователя."
        case .faceIDIsNotAvailable:
            title = "Вход по биоментрии не доступен"
            message = "Зайдите в настройки устройства и разрешите использовать FaceID/TouchID"
        case .faceUnrecognized:
            title = "Биометрия не распознана"
            message = "Не получилось осуществить вход по биометрии, введите Login и Password"
        case .userForbidToUseFaceID:
            title = "Вход по биоментрии запрещен"
            message = "Ранее Вы запретили вход по биометрии. Для предоставления доступа перейдите в настройки и разрешите использовать FaceID."
        case _:
            title = "Ошибка."
            message = "Упс, что-то пошло не так"
        }

        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert
        )



        let yesAction = UIAlertAction(title: "Ok", style: .default, handler: handler)

        alert.addAction(yesAction)

        return alert
    }
}

extension Alerts {
    func showAlert(name: AlertsMessage)-> UIAlertController{
        self.showAlert(name: name, handler: nil)
    }
}
