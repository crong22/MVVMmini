//
//  MainViewController.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class MainViewController : UIViewController {
    let topView = UIView()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let cloudLabel = UILabel()
    let maxmintempLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let tableView = UITableView()
    
    let titleLabel = UILabel()
    let titleImage = UIImageView()
    
    let fiveLabel = UILabel()
    let fiveImage = UIImageView()
    
    //model선언
    let viewmodel = MainViewModel()
    
    var listDate : Weather?
    var safeDayList: [String] = []
    var listcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        viewmodel.inputViewDidLoadTrigger.value = ()
        configureHierarchy()
        configureLayout()
        configureView()
        
        tablecollection()

    }
    
    func bindData() {
        viewmodel.inputViewDidLoadTrigger.value = ()
        
        viewmodel.OuputWheatherData.bind { [self] value in
            guard let data = value else {return}
            //
            var testList : [String : Double ] = [:]
            //
            
            // 요일
            // safeDayList를 빈 배열로 초기화
            var safeDayList: [String] = []
            var dayListSet: Set<String> = []
            // 온도
            var tempDayList : [String] = []
            var valueTemp : [String : String ] = [:]
            
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "E"
            dayFormatter.locale = Locale(identifier: "ko_KR")
            dayFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            //
            
            //
            if let apiDateCount = viewmodel.OuputWheatherData.value?.list.count {
                
                for i in 0..<apiDateCount {
                    if let dateText = viewmodel.OuputWheatherData.value?.list[i].dt_txt {

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
                
                for dateString in dayDateList {
                    if let date = dateFormatter.date(from: dateString) {
                        let dayOfWeek = dayFormatter.string(from: date)
                        dayDateWithDayOfWeek.append("\(dateString) \(dayOfWeek)")
                    }
                }

                // 결과를 UserDefaults에 저장
                UserDefaults.standard.setValue(dayDateWithDayOfWeek, forKey: "dayDate")

            } else {
                print("nil")
            }
            //
            
            var arrayset = Array(dayListSet)
            arrayset.sort()
            //온도
            let apiDateCount = viewmodel.OuputWheatherData.value?.list.count
            for i in 0..<apiDateCount! {
                let dayText = data.list[i].dt_txt
                let apidaydate = dayText?.split(separator: " ")
                //
                testList.updateValue(data.list[i].main.temp!, forKey: "\(String(apidaydate![0]))")
                
                for (key, value) in testList {
                    if arrayset[0] == key {
                        let temp = value - 273.15
                        let daytemp = String(format: "%.1f", temp)
                        firstTemp.append(daytemp)
                        firstTempSet = Set(firstTemp)
                        let firtTempData = [firstTempSet.min(), firstTempSet.max()]
                        UserDefaults.standard.setValue(firtTempData, forKey: "firtTempData")
                    }else if arrayset[1] == key {
                        let temp = value - 273.15
                        let daytemp = String(format: "%.1f", temp)
                        twoTemp.append(daytemp)
                        twoTempSet = Set(twoTemp)
                        let twoTempData = [twoTempSet.min(), twoTempSet.max()]
                        UserDefaults.standard.setValue(twoTempData, forKey: "twoTempData")
                    }else if arrayset[2] == key {
                        let temp = value - 273.15
                        let daytemp = String(format: "%.1f", temp)
                        threeTemp.append(daytemp)
                        threeTempSet = Set(threeTemp)
                        let threeTempData = [threeTempSet.min(), threeTempSet.max()]
                        UserDefaults.standard.setValue(threeTempData, forKey: "threeTempData")
                    }else if arrayset[3] == key {
                        let temp = value - 273.15
                        let daytemp = String(format: "%.1f", temp)
                        fourTemp.append(daytemp)
                        fourTempSet = Set(fourTemp)
                        let fourTempData = [fourTempSet.min(), fourTempSet.max()]
                        UserDefaults.standard.setValue(fourTempData, forKey: "fourTempSet")
                    }else if arrayset[4] == key {
                        let temp = value - 273.15
                        let daytemp = String(format: "%.1f", temp)
                        fiveTemp.append(daytemp)
                        fiveTempSet = Set(fiveTemp)
                        let fiveTempData = [fiveTempSet.min(), fiveTempSet.max()]
                        UserDefaults.standard.setValue(fiveTempData, forKey: "fiveTempData")
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
                    print("0", iconList)
                }else if arrayset[1] == key {
                    iconList.append(value)
                    print("1", iconList)
                }else if arrayset[2] == key {
                    iconList.append(value)
                    print("2", iconList)
                }else if arrayset[3] == key {
                    iconList.append(value)
                    print("3", iconList)
                }else if arrayset[4] == key {
                    iconList.append(value)
                    print("4", iconList)
                }
            }

            UserDefaults.standard.setValue(iconList, forKey: "iconList")

            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
        viewmodel.OuputCurrentWheatherData.bind { data in
            // city
            self.cityLabel.text = data?.name
            
            // temp
            guard let temp = data?.main.temp  else { return }
            let num = String(format: "%.1f", temp)
            self.tempLabel.text = "  \(num)°"
            
            // clouds
            guard let cloudname = data?.weather.first?.description else { return }
            self.cloudLabel.text = cloudname
            
            // max temp , min temp
            guard let max = data?.main.temp_max  else { return }
            let maxtemp = String(format: "%.1f", max)
            let todayTemp  = UserDefaults.standard.array(forKey: "firtTempData")
            self.maxmintempLabel.text = "최고 : \(maxtemp)° | 최저 : \(todayTemp![0])°"
        }
    }
    
    func tablecollection() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.id)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.id)
        
    }
    func configureHierarchy() {
        view.addSubview(topView)
        
        topView.addSubview(cityLabel)
        topView.addSubview(tempLabel)
        topView.addSubview(cloudLabel)
        topView.addSubview(maxmintempLabel)
        
        view.addSubview(collectionView)
        view.addSubview(titleImage)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        view.addSubview(fiveImage)
        view.addSubview(fiveLabel)
    }
    
    func configureLayout() {

        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(170)
        }
        
        cityLabel.text = "Jeju City"
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        cityLabel.font = .systemFont(ofSize: 32, weight: .bold)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.top)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(35)
        }
        
        tempLabel.text = "5.9°"
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.font = .systemFont(ofSize: 90, weight: .regular)
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(85)
        }
        
        cloudLabel.text = "Broken clouds"
        cloudLabel.textColor = .white
        cloudLabel.textAlignment = .center
        cloudLabel.font = .systemFont(ofSize: 20, weight: .bold)
        cloudLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(20)
        }
        
        maxmintempLabel.text = "최고 :7.0° | 최저 :-4.2°"
        maxmintempLabel.textColor = .white
        maxmintempLabel.textAlignment = .center
        maxmintempLabel.font = .systemFont(ofSize: 20, weight: .bold)
        maxmintempLabel.snp.makeConstraints { make in
            make.top.equalTo(cloudLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(130)
        }
        
        titleImage.image = UIImage(systemName: "calendar")
        titleImage.tintColor = .white
        titleImage.contentMode = .center
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.top).offset(-35)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.height.equalTo(35)
            make.width.equalTo(15)
        }
        
        titleLabel.text = "3일간 간격의 일기예보"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.top).offset(-35)
            make.leading.equalTo(titleImage).offset(21)
            make.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(300)
        }
        
        fiveImage.image = UIImage(systemName: "calendar")
        fiveImage.tintColor = .white
        fiveImage.contentMode = .center
        fiveImage.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).offset(-35)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.height.equalTo(35)
            make.width.equalTo(15)
        }
        
        fiveLabel.text = "5일간 간격의 일기예보"
        fiveLabel.textColor = .white
        fiveLabel.textAlignment = .left
        fiveLabel.font = .systemFont(ofSize: 14, weight: .regular)
        fiveLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).offset(-35)
            make.leading.equalTo(titleImage).offset(21)
            make.height.equalTo(35)
        }
        
    }
    
    func configureView() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 100
        layout.itemSize = CGSize(width: width/5, height: width/2)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 0)
        return layout
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath) as! MainTableViewCell
        let data = viewmodel.OuputWheatherData.value?.list[indexPath.row]
        let iconDay = UserDefaults.standard.array(forKey: "iconList")!
        
        if let dayDateList = UserDefaults.standard.array(forKey: "dayDate") {
            let dateDay = dayDateList[indexPath.row] as! String
            let splitDay = dateDay.split(separator: " ")
            
            let imageIcon = iconDay[indexPath.row]
            let url = URL(string: "https://openweathermap.org/img/wn/\(imageIcon)@2x.png")
            cell.weatherImage.kf.setImage(with: url)
            
            
            if indexPath.row == 0 {
                if let firstTemp  = UserDefaults.standard.array(forKey: "firtTempData") {
                    cell.minTempLabel.text = "최저 \(firstTemp[0])°"
                    cell.maxTempLabel.text = "최고 \(firstTemp[1])°"
                }
                cell.dayLabel.text = "오늘"

            }else if indexPath.row == 1{
                cell.dayLabel.text = "\(splitDay[1])"

                if let twoTemp  = UserDefaults.standard.array(forKey: "twoTempData") {
                    cell.minTempLabel.text = "최저 \(twoTemp[0])°"
                    cell.maxTempLabel.text = "최고 \(twoTemp[1])°"
                }
            }else if indexPath.row == 2 {
                cell.dayLabel.text = "\(splitDay[1])"

                if let threeTemp  = UserDefaults.standard.array(forKey: "threeTempData") {
                    cell.minTempLabel.text = "최저 \(threeTemp[0])°"
                    cell.maxTempLabel.text = "최고 \(threeTemp[1])°"
                }
            }else if indexPath.row == 3{
                cell.dayLabel.text = "\(splitDay[1])"

                if let fourTemp  = UserDefaults.standard.array(forKey: "fourTempData") {
                    cell.minTempLabel.text = "최저 \(fourTemp[0])°"
                    cell.maxTempLabel.text = "최고 \(fourTemp[1])°"
                }
            }else if indexPath.row == 4 {
                cell.dayLabel.text = "\(splitDay[1])"

                if let fiveTemp  = UserDefaults.standard.array(forKey: "fiveTempData") {
                    cell.minTempLabel.text = "최저 \(fiveTemp[0])°"
                    cell.maxTempLabel.text = "최고 \(fiveTemp[1])°"
                }
            }
        }else {
            print("error")
        }
        
        return cell
    }
    
    
}

extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewmodel.OuputWheatherData.value?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as! MainCollectionViewCell
        let data = viewmodel.OuputWheatherData.value?.list[indexPath.row]
        
        // 날짜(시간)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")  // TimeZone
        
        if let apiDate = data?.dt_txt {
            let strdate = apiDate.index(apiDate.startIndex, offsetBy: 10) ... apiDate.index(apiDate.endIndex, offsetBy: -7)
            let apiDate = apiDate[strdate]
            UserDefaults.standard.setValue(apiDate, forKey: "apiDate")
        }else{
            print("error")
        }
        
        
        let apiDate = UserDefaults.standard.string(forKey: "apiDate")
        cell.timeLabel.text = apiDate! + "시"
        //
        
        if var temp = data?.main.temp {
            temp = temp - 273.15
            UserDefaults.standard.setValue(temp, forKey: "temp")
        }
        let temp = UserDefaults.standard.double(forKey: "temp") 
        let apitemp = String(format: "%.1f", temp)
        cell.tempLabel.text = apitemp + "°"
        //
        
        // 날씨아이콘 (Kf)
        let imageIcon = data?.weather[0].icon
        let url = URL(string: "https://openweathermap.org/img/wn/\(imageIcon!)@2x.png")
        cell.cloudImage.kf.setImage(with: url)
        //
        
        return cell
    }
    
    
}
