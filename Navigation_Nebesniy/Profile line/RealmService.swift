//
//  RealmService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 23.03.2023.
//

import Foundation
import RealmSwift

protocol RealmService: AnyObject {
    func create(login: Login, update: Bool) -> Bool
    func fetchLogin() -> Login?
}

final class RealmServiceImp {

    private let key: [UInt8] = [0x30, 0x30, 0x45, 0x45, 0x39, 0x30, 0x36, 0x39, 0x2d, 0x35, 0x39, 0x33, 0x31, 0x2d, 0x34, 0x46, 0x38, 0x45, 0x2d, 0x39, 0x31, 0x44, 0x30, 0x2d, 0x35, 0x44, 0x45, 0x43, 0x45, 0x37, 0x39, 0x43, 0x33, 0x42, 0x39, 0x41, 0x30, 0x30, 0x45, 0x45, 0x39, 0x30, 0x36, 0x39, 0x2d, 0x35, 0x39, 0x33, 0x31, 0x2d, 0x34, 0x46, 0x38, 0x45, 0x2d, 0x39, 0x31, 0x44, 0x30, 0x2d, 0x35, 0x44, 0x45, 0x43]
//    "00EE9069-5931-4F8E-91D0-5DECE79C3B9A00EE9069-5931-4F8E-91D0-5DEC"

    private func configRealm() -> Realm.Configuration{
        let dataKey = Data(key)

        return Realm.Configuration(encryptionKey: dataKey)
    }
}

extension RealmServiceImp: RealmService {

    func create(login: Login, update: Bool) -> Bool {
        var config = self.configRealm()
        do {
            let realm = try Realm(configuration: config)

            let handler: () -> Void = {
                if update {
                    realm.create(
                        LoginRealmModel.self,
                        value: login.keyedValues,
                        update: .modified
                    )
                } else {
                    realm.create(
                        LoginRealmModel.self,
                        value: login.keyedValues
                    )
                }

            }

            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }

            return true
        } catch {
            return false
        }
    }

    func fetchLogin() -> Login? {
        var config = self.configRealm()
        do {
            let realm = try Realm(configuration: config)

            let objects = realm.objects(LoginRealmModel.self)

            guard let loginRealmModels = Array(objects) as? [LoginRealmModel] else {
                return nil
            }
            let loginArray = loginRealmModels.map { Login(loginRealmModel: $0) }
            guard loginArray.count > 0 else {
                return nil
            }
            return loginArray[0]
        } catch {
            return nil
        }
    }
}
