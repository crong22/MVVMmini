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
    
    var fiveDidLoadTrigger : Obsevable<Void?> = Obsevable(nil)
    
    var OuputWheatherData : Obsevable<Weather?> = Obsevable(nil)
    
    var OuputCurrentWheatherData : Obsevable<WeatherData?> = Obsevable(nil)
    
    // 5일 날씨 데이터 저장
    var OutputfivedaysData : Obsevable<[String]?> = Obsevable([])
    var OutputDayDateData : Obsevable<[String]?> = Obsevable([])
    var OutputFirstTempData : Obsevable<[String]?> = Obsevable([])
    var OutputTwoTempData : Obsevable<[String]?> = Obsevable([])
    var OutputThreeTempData : Obsevable<[String]?> = Obsevable([])
    var OutputFourTempData : Obsevable<[String]?> = Obsevable([])
    var OutputFiveTempData : Obsevable<[String]?> = Obsevable([])
    var OutputiconListData : Obsevable<[String]?> = Obsevable([])
    var OutputdaysDateListData : Obsevable<[String]?> = Obsevable([])
    
    init() {
        change()
    }
    
    func change() {
        inputViewDidLoadTrigger.bind { _ in
            self.request(id : self.inputViewcityID.value ?? 1835847)
            self.callRequest(id :self.inputViewcityID.value ?? 1835847)
        }
        
        OuputWheatherData.bindTwo { data in
 
            guard let data = data else {return}
            // 일, 온도
            var dayTempDict : [String : Double ] = [:]
            
            // 요일
            var safeDayList: [String] = []
            var dayListSet: Set<String> = []
            
            // 온도
            var tempDayList : [String] = []
            
            // 5일 온도
            var firstTemp : [String] = []
            var firstTempSet : Set<String> = []
            var twoTemp : [String] = []
            var twoTempSet : Set<String> = []
            var threeTemp : [String] = []
            var threeTempSet : Set<String> = []
            var fourTemp : [String] = []
            var fourTempSet : Set<String> = []
            var fiveTemp : [String] = []
            var fiveTempSet : Set<String> = []
            //
            var test : [Int: [String]]? = [:]
            var testlist = []
            //
            
            // 날짜 포맷 변경 0000-00-00
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

            // 요일 꺼내기 위해 날짜 포맷 변경
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "E"
            dayFormatter.locale = Locale(identifier: "ko_KR")
            dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            //
            
            //
            if let apiDateCount = self.OuputWheatherData.value?.list.count {
                for i in 0..<apiDateCount {
                    if let dateText = self.OuputWheatherData.value?.list[i].dt_txt {

                        // "yyyy-MM-dd HH:mm:ss" 형식의 날짜 문자열에서 "yyyy-MM-dd" 부분만 추출
                        let dateComponents = dateText.split(separator: " ")
                        if let datePart = dateComponents.first {
                            safeDayList.append(String(datePart))
                            tempDayList.append(String(dateComponents[0]))
                        } else {
                            print("11")
                        }
                    } else {
                        print("22")
                    }
                }
                
                dayListSet = Set(safeDayList)
                // Set을 다시 배열로 변환하여 중복 없는 리스트 생성 및 오름차순 정렬
                var dayDateList = Array(dayListSet)
                dayDateList.sort()

                // 요일을 포함한 리스트 생성
                var dayDateWithDayOfWeek: [String] = []
                var daysDateList : [String] = []
                for dateString in dayDateList {
                    if let date = dateFormatter.date(from: dateString) {
                        if dayDateWithDayOfWeek.count == 5 {
                            break
                        }
                        let dayOfWeek = dayFormatter.string(from: date)
                        dayDateWithDayOfWeek.append("\(dateString) \(dayOfWeek)")
                        daysDateList.append(dayOfWeek)
                    }
                }
                

                // 결과를 UserDefaults에 저장
//                UserDefaults.standard.setValue(dayDateWithDayOfWeek, forKey: "dayDate")
                
                // 결과 값 저장 = > OutputDayDateData.value
                self.OutputDayDateData.value = dayDateWithDayOfWeek
                self.OutputdaysDateListData.value = daysDateList
//                print(self.OutputDayDateData.value!)
                
            } else {
                print("nil")
            }
            //
            
            var arrayset = Array(dayListSet)
            arrayset.sort()
            //온도

            let apiDateCount = self.OuputWheatherData.value?.list.count
            for i in 0..<apiDateCount! {
                let dayText = data.list[i].dt_txt
                let apidaydate = dayText?.split(separator: " ")
                //
                dayTempDict.updateValue(data.list[i].main.temp!, forKey: "\(String(apidaydate![0]))")
                for (key, value) in dayTempDict {
                    for num in 0...5 {
                        if arrayset[0] == key {
                            let daytemp = String(format: "%.1f", value)
                            firstTemp.append(daytemp)
                            firstTempSet = Set(firstTemp)
//                            let firstTempData = [firstTempSet.min(), firstTempSet.max()]
//                            UserDefaults.standard.setValue(firtTempData, forKey: "firtTempData")
                            self.OutputFirstTempData.value = Array(firstTempSet)
                        }else if arrayset[1] == key {
                            let daytemp = String(format: "%.1f", value)
                            twoTemp.append(daytemp)
                            twoTempSet = Set(twoTemp)
//                            let twoTempData = [twoTempSet.min(), twoTempSet.max()]
//                            UserDefaults.standard.setValue(twoTempData, forKey: "twoTempData")
                            self.OutputTwoTempData.value = Array(twoTempSet)
                        }else if arrayset[2] == key {
                            let daytemp = String(format: "%.1f", value)
                            threeTemp.append(daytemp)
                            threeTempSet = Set(threeTemp)
//                            let threeTempData = [threeTempSet.min(), threeTempSet.max()]
//                            UserDefaults.standard.setValue(threeTempData, forKey: "threeTempData")
                            self.OutputThreeTempData.value = Array(threeTempSet)
                        }else if arrayset[3] == key {
                            let temp = value - 273.15
                            let daytemp = String(format: "%.1f", value)
                            fourTemp.append(daytemp)
                            fourTempSet = Set(fourTemp)
//                            let fourTempData = [fourTempSet.min(), fourTempSet.max()]
//                            UserDefaults.standard.setValue(fourTempData, forKey: "fourTempSet")
                            self.OutputFourTempData.value = Array(fourTempSet)
                        }else if arrayset[4] == key {
                            let temp = value - 273.15
                            let daytemp = String(format: "%.1f", value)
                            fiveTemp.append(daytemp)
                            fiveTempSet = Set(fiveTemp)
//                            let fiveTempData = [fiveTempSet.min(), fiveTempSet.max()]
//                            UserDefaults.standard.setValue(fiveTempData, forKey: "fiveTempData")
                            self.OutputFiveTempData.value = Array(fiveTempSet)
                        }
                    }
                    
                }
            }
            
            // 아이콘
            var iconDict : [String : String] = [:]
            var iconList : [String] = []
            for i in 0..<apiDateCount! {
                let dayText = data.list[i].dt_txt
                let apidaydate = dayText?.split(separator: " ")
                iconDict.updateValue(data.list[i].weather.first!.icon, forKey: String(apidaydate![0]))
            }
            
            // 순서 정렬 ?..
            let sorticon = iconDict.sorted { $0.key < $1.key }

            for (key, value) in sorticon {
    
                if arrayset[0] == key {
                    iconList.append(value)
 
                }else if arrayset[1] == key {
                    iconList.append(value)
  
                }else if arrayset[2] == key {
                    iconList.append(value)

                }else if arrayset[3] == key {
                    iconList.append(value)

                }else if arrayset[4] == key {
                    iconList.append(value)

                }
            }

//            UserDefaults.standard.setValue(iconList, forKey: "iconList")
            self.OutputiconListData.value = iconList
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
