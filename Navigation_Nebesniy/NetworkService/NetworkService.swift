//
//  NetworkService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 28.02.2023.
//

import Foundation


final class NetworkService {

    static func request(for configuration: AppConfiguration) {
        let stringUrl: String
        switch configuration {
        case .planets(let apiUrl):
            stringUrl = apiUrl
        case .vehicles(let apiUrl):
            stringUrl = apiUrl
        case .starships(let apiUrl):
            stringUrl = apiUrl
        }
        if let url = URL(string: stringUrl) {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data {
                    let dataString = String(data: data, encoding: .utf8)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("🥳 .allHeaderFields", httpResponse.allHeaderFields, "\n 🎉 .statusCode", httpResponse.statusCode)
                }
                if let httpError = error {
                    print("😞 .localizedDescription", httpError.localizedDescription)
//                    Код ошибки без интернета "The Internet connection appears to be offline" finished with error [-1009]
                }
            }
            dataTask.resume()
        }
    }
}

