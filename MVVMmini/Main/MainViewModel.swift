//
//  MainViewModel.swift
//  MVVMmini
//
//  Created by 여누 on 7/11/24.
//

import Foundation

class MainViewModel {
    var inputViewcityID : Int = 1835847
    var inputViewDidLoadTrigger : Obsevable<Void?> = Obsevable(nil)
    
    var OuputWheatherData : Obsevable<Weather?> = Obsevable(nil)
    var OuputCurrentWheatherData : Obsevable<WeatherData?> = Obsevable(nil)
    

    init() {
        change()
    }
    
    func change() {
        inputViewDidLoadTrigger.bind { _ in
            self.request()
            self.callRequest()
        }
    }
    
    func request() {
        APIManager.shared.callRequest(cityid: inputViewcityID) { weather in
            self.OuputWheatherData.value = weather
        }
    }
    
    func callRequest() {
        APIManager.shared.CurrentcallRequest(cityid: inputViewcityID) { value in
            self.OuputCurrentWheatherData.value = value
        }
    }
    
}
