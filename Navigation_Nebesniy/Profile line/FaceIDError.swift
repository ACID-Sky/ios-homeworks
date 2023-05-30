//
//  FaceIDError.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 29.05.2023.
//

import Foundation

enum FaceIDError: Error {
    case faceIDIsNotAvailable
    case faceUnrecognized
    case userForbidToUseFaceID
}
