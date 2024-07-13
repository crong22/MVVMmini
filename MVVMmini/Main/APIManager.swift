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
    
    func callRequest(completionHandler : @escaping (Weather) -> Void ) {
//        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=37.284593&lon=127.015629&lang=kr&appid=\(APIKey.weatherkey)"
        //1835847
        let url = "https://api.openweathermap.org/data/2.5/forecast?id=1835847&appid=\(APIKey.weatherkey)"
//        let url = URL(string: a)!
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
    
    func CurrentcallRequest(completionHandler : @escaping (WeatherData) -> Void ) {
        let url = "https://api.openweathermap.org/data/2.5/weather?id=1835847&units=metric&appid=\(APIKey.weatherkey)"
//        let url = URL(string: a)!
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



