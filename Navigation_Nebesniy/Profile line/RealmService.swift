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


}

extension RealmServiceImp: RealmService {

    func create(login: Login, update: Bool) -> Bool {
        do {
            let realm = try Realm()

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
        do {
            let realm = try Realm()

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
