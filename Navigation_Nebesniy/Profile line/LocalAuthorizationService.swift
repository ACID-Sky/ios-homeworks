//
//  LocalAuthorizationService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 29.05.2023.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {

    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, FaceIDError>) -> Void) {
        let context = LAContext()
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

        var error: NSError? = nil
        let canEvaluate = context.canEvaluatePolicy(policy, error: &error)

        if error != nil {
            return authorizationFinished(.failure(.faceIDIsNotAvailable))
        }

        guard canEvaluate else {
            return authorizationFinished(.failure(.userForbidToUseFaceID))
        }
        context.evaluatePolicy(policy, localizedReason: "?????") { bool, error in
            if error != nil {
                DispatchQueue.main.async {
                    return authorizationFinished(.failure(.faceUnrecognized))
                }
            }

            return authorizationFinished(.success(bool))
        }
        
    }
}
