//
//  City.swift
//  MVVMmini
//
//  Created by 여누 on 7/14/24.
//

import Foundation


struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}

struct city: Decodable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coordinate
}
