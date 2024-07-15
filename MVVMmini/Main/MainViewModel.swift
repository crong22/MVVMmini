//
//  MainViewModel.swift
//  MVVMmini
//
//  Created by 여누 on 7/11/24.
//

import Foundation

class MainViewModel {
    var inputViewcityID : Obsevable<Int?> = Obsevable(nil)
    var inputViewDidLoadTrigger : Obsevable<Void?> = Obsevable(nil)
    
    var inputViewcityIDTrigger : Obsevable<Void?> = Obsevable(nil)
    
    var OuputWheatherData : Obsevable<Weather?> = Obsevable(nil)
    var OuputCurrentWheatherData : Obsevable<WeatherData?> = Obsevable(nil)
    

    init() {
        change()
    }
    
    func change() {
        inputViewDidLoadTrigger.bind { _ in
            print("inputViewDidLoadTrigger 변동")
            print("id", self.inputViewcityID.value)
            self.request(id : self.inputViewcityID.value ?? 1835847)
            self.callRequest(id :self.inputViewcityID.value ?? 1835847)
        }
        
    }
    
    func request(id : Int) {
        APIManager.shared.callRequest(cityid: id) { weather in
            self.OuputWheatherData.value = weather
        }
    }
    
    func callRequest(id : Int) {
        APIManager.shared.CurrentcallRequest(cityid: id) { value in
            self.OuputCurrentWheatherData.value = value
        }
    }
    
}
