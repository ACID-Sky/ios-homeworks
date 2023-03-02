//
//  JSONData.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 02.03.2023.
//

import Foundation

struct UserJSONData {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

struct Planet: Decodable {
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: String
    let population: String
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter
        case climate
        case gravity
        case terrain
        case surfaceWater = "surface_water"
        case population
        case residents
        case films
        case created
        case edited
        case url
    }
}

//struct Planet: Decodable {
//    let name: String
//    let rotationPeriod: Int
//    let orbitalPeriod: Int
//    let diameter: Int
//    let climate: String
//    let gravity: String
//    let terrain: String
//    let surfaceWater: Int
//    let population: Int
//    let residents: [String]
//    let films: [String]
//    let created: String
//    let edited: String
//    let url: String
