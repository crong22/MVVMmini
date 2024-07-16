//
//  MainViewController.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import SnapKit
import Kingfisher
import MapKit
import CoreLocation

var mapLocate = CLLocationCoordinate2D()

class MainViewController : UIViewController {
    // 스크롤뷰
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // 현재 날씨정보
    let topView = UIView()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let cloudLabel = UILabel()
    let maxmintempLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let tableView = UITableView()
    
    // 3일간격의일기예보
    let titleLabel = UILabel()
    let titleImage = UIImageView()
    // 5일간격의일기예보
    let fiveLabel = UILabel()
    let fiveImage = UIImageView()
    
    // 지도 ,시티목록 버튼
    let bottonView = UIView()
    let rightButton = UIButton()
    let leftButton = UIButton()
    
    // 위치
    let mapView = MKMapView()
    let mapImage = UIImageView()
    let mapLabel = UILabel()
    
    
    // 바람속도, 구름
    let windCloud = UIView()
    let windImage = UIImageView()
    let windSpeedLable = UILabel()
    let windSpeedValueLabel = UILabel()
    let cloudImage = UIImageView()
    let cloud = UILabel()
    let cloudValueLabel = UILabel()
    
    // 기압, 습도
    let barometerHumidity = UIView()
    let barometerImage = UIImageView()
    let barometerLabel = UILabel()
    let barometerValueLabel = UILabel()
    let barometerUnitLabel = UILabel()
    
    let humidityImage = UIImageView()
    let humidityLabel = UILabel()
    let humidityValueLable = UILabel()
    
    //model선언
    let viewmodel = MainViewModel()
    
    var city : city?
    
    var listDate : Weather?
    var safeDayList: [String] = []
    var listcount = 0
    
    // 현재위치
    let locationManager = CLLocationManager()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceLocationAuthorization()
        bindData()

        configureHierarchy()
        configureLayout()
        configureView()
        
        tablecollection()
        
        rightButton.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .white  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationItem.hidesBackButton = true
        
        // 현재위치
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        //
    }

    override func viewDidAppear(_ animated: Bool) {
        print("didappear")
        print("city", city?.name)
        guard let city = city else { return }
        bindData()
        
    }
    
    @objc func rightButtonClicked() {
        print("클릭")
        navigationController?.pushViewController(FindViewController(), animated: true)
    }
    
    @objc func leftButtonClicked() {
        print(#function)
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
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
            
            // map
            print("맵변동")
            let vc = MapViewController()
            let lat = self.viewmodel.OuputCurrentWheatherData.value?.coord.lat
            let lon = self.viewmodel.OuputCurrentWheatherData.value?.coord.lon
            let center = CLLocationCoordinate2D(latitude: lat ?? 37.5833, longitude: lon ?? 127.0)
            print("맵변동 Center", center)
            vc.map = center
            self.mapView.mapType = MKMapType.mutedStandard
            self.mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            print("강수량",data?.rain?.the1H)
            guard let rainData = data?.rain?.the1H else {
                self.mapView.removeAnnotations(self.mapView.annotations)
                annotation.title = "0"
                vc.raindata = 0
                self.mapView.addAnnotation(annotation)
                return
            }
            self.mapView.removeAnnotations(self.mapView.annotations)
            annotation.title = "\(Int(rainData))"
            vc.raindata = Int(rainData)
            self.mapView.addAnnotation(annotation)
            

            // windSpeed , cloud, barometer, humidity
            guard let windspeed = data?.wind.speed, let cloud = data?.clouds.all else {return}
            self.windSpeedValueLabel.text = "\(windspeed)m/s"
            self.cloudValueLabel.text = "\(cloud)%"
            guard let barometer = data?.main.pressure, let humidity = data?.main.humidity else {return}
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let baronum = numberFormatter.string(for: barometer)!
            self.barometerValueLabel.text = baronum
            self.humidityValueLable.text = "\(humidity)%"
            
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(topView)
        
        topView.addSubview(cityLabel)
        topView.addSubview(tempLabel)
        topView.addSubview(cloudLabel)
        topView.addSubview(maxmintempLabel)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(titleImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)
        
        contentView.addSubview(fiveImage)
        contentView.addSubview(fiveLabel)
        
        contentView.addSubview(mapView)
        contentView.addSubview(mapImage)
        contentView.addSubview(mapLabel)
        
        view.addSubview(bottonView)
        bottonView.addSubview(rightButton)
        bottonView.addSubview(leftButton)
        
        contentView.addSubview(windCloud)
        windCloud.addSubview(windImage)
        windCloud.addSubview(windSpeedValueLabel)
        windCloud.addSubview(windSpeedLable)
        windCloud.addSubview(cloudImage)
        windCloud.addSubview(cloudValueLabel)
        windCloud.addSubview(cloud)
        
        contentView.addSubview(barometerHumidity)
        barometerHumidity.addSubview(barometerImage)
        barometerHumidity.addSubview(barometerLabel)
        barometerHumidity.addSubview(barometerValueLabel)
        barometerHumidity.addSubview(barometerUnitLabel)
        
        barometerHumidity.addSubview(humidityImage)
        barometerHumidity.addSubview(humidityLabel)
        barometerHumidity.addSubview(humidityValueLable)
        
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1400)
        }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(170)
        }
        
        cityLabel.text = "Jeju City"
        cityLabel.textColor = .orange
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
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
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
            make.top.equalTo(collectionView.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(250)
        }
        
        mapView.backgroundColor = .blue
        mapView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(250)
        }

        mapImage.image = UIImage(systemName: "thermometer")
        mapImage.tintColor = .white
        mapImage.contentMode = .center
        mapImage.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).offset(-35)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
            make.height.equalTo(35)
            make.width.equalTo(15)
        }
        
        mapLabel.text = "위치"
        mapLabel.textColor = .white
        mapLabel.textAlignment = .left
        mapLabel.font = .systemFont(ofSize: 14, weight: .regular)
        mapLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).offset(-35)
            make.leading.equalTo(mapImage).offset(21)
            make.height.equalTo(35)
        }
        
        bottonView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(55)
        }
        
        rightButton.tintColor = .white
        rightButton.contentMode = .scaleToFill
        rightButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(bottonView.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(bottonView.safeAreaLayoutGuide).offset(-10)
            make.height.width.equalTo(35)
        }
        
        leftButton.tintColor = .white
        leftButton.setImage(UIImage(systemName: "map"), for: .normal)
        leftButton.contentMode = .scaleToFill
        leftButton.snp.makeConstraints { make in
            make.top.equalTo(bottonView.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(bottonView.safeAreaLayoutGuide).offset(10)
            make.height.width.equalTo(35)
        }
        
        fiveImage.image = UIImage(systemName: "calendar")
        fiveImage.tintColor = .white
        fiveImage.contentMode = .center
        fiveImage.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).offset(-35)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
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
        
        windCloud.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(150)
        }
        
        windImage.image = UIImage(systemName: "wind")
        windImage.tintColor = .lightGray
        windImage.contentMode = .center
        windImage.snp.makeConstraints { make in
            make.top.equalTo(windCloud.safeAreaLayoutGuide)
            make.leading.equalTo(windCloud.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        
        windSpeedLable.text = "바람 속도"
        windSpeedLable.textColor = .lightGray
        windSpeedLable.textAlignment = .left
        windSpeedLable.font = .systemFont(ofSize: 14, weight: .regular)
        windSpeedLable.snp.makeConstraints { make in
            make.top.equalTo(windCloud.safeAreaLayoutGuide)
            make.leading.equalTo(windImage).offset(21)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        
        windSpeedValueLabel.text = "1.35m/s"
        windSpeedValueLabel.font = .systemFont(ofSize: 40, weight: .bold)
        windSpeedValueLabel.textColor = .white
        windSpeedValueLabel.textAlignment = .left
        windSpeedValueLabel.snp.makeConstraints { make in
            make.top.equalTo(windSpeedLable.snp.bottom)
            make.leading.equalTo(windCloud.safeAreaLayoutGuide)
            make.width.equalTo(158)
        }
        
        cloudImage.image = UIImage(systemName: "drop.fill")
        cloudImage.tintColor = .lightGray
        cloudImage.contentMode = .center
        cloudImage.snp.makeConstraints { make in
            make.top.equalTo(windCloud.safeAreaLayoutGuide)
            make.trailing.equalTo(windCloud.safeAreaLayoutGuide).offset(-140)
            make.height.equalTo(35)
        }
        
        cloud.text = "구름"
        cloud.textColor = .lightGray
        cloud.textAlignment = .left
        cloud.font = .systemFont(ofSize: 14, weight: .regular)
        cloud.snp.makeConstraints { make in
            make.top.equalTo(windCloud.safeAreaLayoutGuide)
            make.leading.equalTo(cloudImage).offset(21)
            make.height.equalTo(35)
            make.width.equalTo(80)
        }

        cloudValueLabel.text = "50%"
        cloudValueLabel.font = .systemFont(ofSize: 40, weight: .bold)
        cloudValueLabel.textColor = .white
        cloudValueLabel.textAlignment = .left
        cloudValueLabel.snp.makeConstraints { make in
            make.top.equalTo(windSpeedLable.snp.bottom)
            make.trailing.equalTo(windCloud.safeAreaLayoutGuide)
            make.width.equalTo(155)
        }
        
        barometerHumidity.snp.makeConstraints { make in
            make.top.equalTo(windCloud.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(150)
        }
        
        barometerImage.image = UIImage(systemName: "barometer")
        barometerImage.tintColor = .lightGray
        barometerImage.contentMode = .center
        barometerImage.snp.makeConstraints { make in
            make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.height.equalTo(35)
        }
        
        barometerLabel.text = "기압"
        barometerLabel.textColor = .lightGray
        barometerLabel.textAlignment = .left
        barometerLabel.font = .systemFont(ofSize: 14, weight: .regular)
        barometerLabel.snp.makeConstraints { make in
            make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.leading.equalTo(barometerImage).offset(21)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        
        barometerValueLabel.text = "1,020"
        barometerValueLabel.font = .systemFont(ofSize: 40, weight: .bold)
        barometerValueLabel.textColor = .white
        barometerValueLabel.textAlignment = .left
        barometerValueLabel.snp.makeConstraints { make in
            make.top.equalTo(barometerLabel.snp.bottom)
            make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.width.equalTo(150)
        }
        
        barometerUnitLabel.text = "hpa"
        barometerUnitLabel.font = .systemFont(ofSize: 14, weight: .bold)
        barometerUnitLabel.textColor = .white
        barometerUnitLabel.textAlignment = .left
        barometerUnitLabel.snp.makeConstraints { make in
            make.top.equalTo(barometerValueLabel.snp.bottom)
            make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.width.equalTo(50)
        }
        
        humidityImage.image = UIImage(systemName: "humidity")
        humidityImage.tintColor = .lightGray
        humidityImage.contentMode = .center
        humidityImage.snp.makeConstraints { make in
            make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.trailing.equalTo(barometerHumidity.safeAreaLayoutGuide).offset(-140)
            make.height.equalTo(35)
        }
        
        humidityLabel.text = "습도"
        humidityLabel.textColor = .lightGray
        humidityLabel.textAlignment = .left
        humidityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.leading.equalTo(humidityImage).offset(21)
            make.height.equalTo(35)
            make.width.equalTo(80)
        }

        humidityValueLable.text = "73%"
        humidityValueLable.font = .systemFont(ofSize: 40, weight: .bold)
        humidityValueLable.textColor = .white
        humidityValueLable.textAlignment = .left
        humidityValueLable.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom)
            make.trailing.equalTo(barometerHumidity.safeAreaLayoutGuide)
            make.width.equalTo(155)
        }
    }
    
    func configureView() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        tableView.backgroundColor = .black
        windCloud.backgroundColor = .black
        barometerHumidity.backgroundColor = . black
        bottonView.backgroundColor = .black
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

extension MainViewController {
    // 1 ) 사용자에게 권한 요청을 하기 위해서, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        // locationServicesEnabled() 타입 매서드라 CLLocationManager.locationServicesEnabled()로 호출이 가능
        if CLLocationManager.locationServicesEnabled() {
            // 2 ) 현재 사용자 위치 권환 상태 확인
            checkCurrentLocationAuthorization()
        }else {
            print("위치 서비스 OFF, 위치 권환 요청 X")
        }
    }
    
    // 2 ) 현재 사용자 위치 권환 상태 확인
    func checkCurrentLocationAuthorization() {
        print(#function)
        var status = locationManager.authorizationStatus
        
        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        // @unknown default: 새로운 버전에 대한 케이스에대한 대처가 필요하기 때문에 생성
        // 대신, default를 사용하면 @unknown default 필요없어짐
        switch status {
        case .notDetermined:
            print("이 권한에서만 권한 문구를 띄울 수 있음")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("iOS 설정 창으로 이동하라는 alert")
        case .authorizedWhenInUse:
            print("위치 정보 알려달라고 로직을 구성")
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath) as! MainTableViewCell
        let data = viewmodel.OuputWheatherData.value?.list[indexPath.row]
        if let iconDay = UserDefaults.standard.array(forKey: "iconList"){
            
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

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            let vc = MapViewController()
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)

            setRegionAndAnnotation(center: coordinate)
        }

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "iOS14이상")
        checkDeviceLocationAuthorization()
    }
}
