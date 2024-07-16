//
//  CuWeather.swift
//  MVVMmini
//
//  Created by 여누 on 7/11/24.
//


import Foundation

import Foundation

struct WeatherData: Decodable {
    let coord: Coordsys
    let weather: [Weathersys]
    let base: String
    let main: Mainsys
    let visibility: Int
    let wind: Windsys
    let clouds: Cloudssys
    let dt: Int
    let sys: Syssys?
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    let rain : Rainsys?
}

struct Coordsys: Decodable {
    let lon: Double
    let lat: Double
}

struct Weathersys: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Rainsys: Decodable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Mainsys: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Windsys: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Cloudssys: Decodable {
    let all: Int
}

struct Syssys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
