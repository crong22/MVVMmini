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
    
    func callRequest(completionHandler : @escaping ([Weather]) -> Void ) {
        let a = "https://api.openweathermap.org/data/2.5/forecast?lat=37.48547107640463&lon=126.93567839430115&appid=\(APIKey.weatherkey)"
        let url = URL(string: a)!
        AF.request(url).responseDecodable(of: [Weather].self) { response in
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
        let a = "https://api.openweathermap.org/data/2.5/weather?lat=37.48547107640463&lon=126.93567839430115&appid=\(APIKey.weatherkey)"
        let url = URL(string: a)!
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



