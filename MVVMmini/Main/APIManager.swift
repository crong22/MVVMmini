//
//  APIManager.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    func callRequest(cityid: Int ,completionHandler : @escaping (Weather) -> Void ) {

        let url = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityid)&units=metric&appid=\(APIKey.weatherkey)"

        AF.request(url).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let success):
                print(" callRequest success")
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func CurrentcallRequest(cityid: Int ,completionHandler : @escaping (WeatherData) -> Void ) {
        let url = "https://api.openweathermap.org/data/2.5/weather?id=\(cityid)&units=metric&appid=\(APIKey.weatherkey)"

        AF.request(url).responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let success):
                print(" CurrentcallRequest success")
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}



