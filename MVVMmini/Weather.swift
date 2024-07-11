//
//  Weather.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import Foundation

struct Weather: Decodable {
    let list: [List]
    let city: City
}

struct List: Decodable {
    let dt: Int?
    let main: Main
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let sys: Sys
    let dt_txt: String?
}

struct Main: Decodable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let sea_level: Int?
    let grnd_level: Int?
    let humidity: Int?
    let temp_kf: Double?
}

struct WeatherElement: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Clouds: Decodable {
    let all: Int?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Rain: Decodable {
    let three_h: Double?

    enum CodingKeys: String, CodingKey {
        case three_h = "3h"
    }
}

struct Sys: Decodable {
    let pod: String?
}

struct City: Decodable {
    let id: Int?
    let name: String?
    let coord: Coord
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

struct Coord: Decodable {
    let lat: Double?
    let lon: Double?
}
