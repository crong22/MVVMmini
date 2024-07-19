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
    
    // 날씨정보(현재)
    let topView = UIView()
    let cityLabel:  UILabel = {
        let label = UILabel()
        label.text = "Jeju City"
        label.textColor = .orange
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    let tempLabel : UILabel = {
        let label = UILabel()
        label.text = "-°"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 90, weight: .regular)
        return label
    }()
    let cloudLabel : UILabel = {
        let label = UILabel()
        label.text = "Broken clouds"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let maxmintempLabel : UILabel = {
        let label = UILabel()
        label.text = "최고 :-° | 최저 :-°"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let tableView = UITableView()
    
    // 3일간격의일기예보
    let threetitleLabel : UILabel = {
        let label = UILabel()
        label.text = "3일간 간격의 일기예보"
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let threetitleImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    // 5일간격의일기예보
    let fivetitleLabel : UILabel = {
        let label = UILabel()
        label.text = "5일간 간격의 일기예보"
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let fivetitleImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    // 메인화면 (지도 - 강수량표시)
    let mapView = MKMapView()
    let mapImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "thermometer")
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    let mapLabel : UILabel = {
        let label = UILabel()
        label.text = "위치"
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // 바람속도, 구름
    let windCloud = UIView()
    let windImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "wind")
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        return imageView
    }()
    let windSpeedLable : UILabel = {
        let label = UILabel()
        label.text = "바람 속도"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let windSpeedValueLabel : UILabel = {
        let label = UILabel()
        label.text = "-m/s"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    let cloudImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "drop.fill")
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        return imageView
    }()
    let bottomcloudLabel : UILabel = {
        let label = UILabel()
        label.text = "구름"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let cloudValueLabel : UILabel = {
        let label = UILabel()
        label.text = "-%"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    // 기압, 습도
    let barometerHumidity = UIView()
    let barometerImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "barometer")
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        return imageView
    }()
    let barometerLabel : UILabel = {
        let label = UILabel()
        label.text = "기압"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let barometerValueLabel : UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    let barometerUnitLabel : UILabel = {
        let label = UILabel()
        label.text = "hpa"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    let humidityImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "humidity")
        imageView.tintColor = .lightGray
        imageView.contentMode = .center
        return imageView
    }()
    let humidityLabel : UILabel = {
        let label = UILabel()
        label.text = "습도"
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let humidityValueLable : UILabel = {
        let label = UILabel()
        label.text = "-%"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    // 지도(왼쪽버튼) ,시티목록(오른쪽버튼) 버튼
    let bottonView = UIView()
    let cityButton : UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.contentMode = .scaleToFill
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
    let mapButton : UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.contentMode = .scaleToFill
        return button
    }()
    
    //model선언
    let viewmodel = MainViewModel()
    
    var city : city?
    
    var listDate : Weather?
    var safeDayList: [String] = []
    var listcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        tablecollection()
        
        cityButton.addTarget(self, action: #selector(cityButtonClicked), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard city != nil else { return }
        bindData()
        
    }
    
    @objc func cityButtonClicked() {
        navigationController?.pushViewController(FindViewController(), animated: true)
    }
    
    @objc func mapButtonClicked() {
        //        navigationController?.pushViewController(MapViewController(), animated: true)
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
        
        viewmodel.OutputiconListData.bind {_ in
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
        //        viewmodel.OutputCurrentWheatherData.bind { data in
        ////            // city
        ////            self.cityLabel.text = data?.name
        ////
        ////            // temp
        ////            guard let temp = data?.main.temp  else { return }
        ////            let num = String(format: "%.1f", temp)
        ////            self.tempLabel.text = "  \(num)°"
        ////
        ////            // clouds
        ////            guard let cloudname = data?.weather.first?.description else { return }
        ////            self.cloudLabel.text = cloudname
        ////
        ////            // max temp , min temp
        ////            guard let max = data?.main.temp_max  else { return }
        ////            let maxtemp = String(format: "%.1f", max)
        ////            let todayTemp  = UserDefaults.standard.array(forKey: "firtTempData")
        ////            self.maxmintempLabel.text = "최고 : \(maxtemp)° | 최저 : \(todayTemp![0])°"
        ////
        ////            // map
        ////            print("맵변동")
        ////            let vc = MapViewController()
        ////            let lat = self.viewmodel.OuputCurrentWheatherData.value?.coord.lat
        ////            let lon = self.viewmodel.OuputCurrentWheatherData.value?.coord.lon
        ////            let center = CLLocationCoordinate2D(latitude: lat ?? 37.5833, longitude: lon ?? 127.0)
        ////            print("맵변동 Center", center)
        ////            vc.map = center
        ////            self.mapView.mapType = MKMapType.mutedStandard
        ////            self.mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        ////            let annotation = MKPointAnnotation()
        ////            annotation.coordinate = center
        ////            print("강수량",data?.rain?.the1H)
        ////            guard let rainData = data?.rain?.the1H else {
        ////                self.mapView.removeAnnotations(self.mapView.annotations)
        ////                annotation.title = "0"
        ////                vc.raindata = 0
        ////                self.mapView.addAnnotation(annotation)
        ////                return
        ////            }
        ////            self.mapView.removeAnnotations(self.mapView.annotations)
        ////            annotation.title = "\(Int(rainData))"
        ////            vc.raindata = Int(rainData)
        ////            self.mapView.addAnnotation(annotation)
        ////
        ////            // windSpeed , cloud, barometer, humidity
        ////            guard let windspeed = data?.wind.speed, let cloud = data?.clouds.all else {return}
        ////            print(cloud)
        ////            self.windSpeedValueLabel.text = "\(windspeed)m/s"
        ////            self.cloudValueLabel.text = "\(cloud)%"
        ////            guard let barometer = data?.main.pressure, let humidity = data?.main.humidity else {return}
        ////            let numberFormatter = NumberFormatter()
        ////            numberFormatter.numberStyle = .decimal
        ////            let baronum = numberFormatter.string(for: barometer)!
        ////            self.barometerValueLabel.text = baronum
        ////            self.humidityValueLable.text = "\(humidity)%"
        //
        //        }
        //    }
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
            contentView.addSubview(threetitleImage)
            contentView.addSubview(threetitleLabel)
            contentView.addSubview(tableView)
            
            contentView.addSubview(fivetitleLabel)
            contentView.addSubview(fivetitleImage)
            
            contentView.addSubview(mapView)
            contentView.addSubview(mapImage)
            contentView.addSubview(mapLabel)
            
            view.addSubview(bottonView)
            bottonView.addSubview(cityButton)
            bottonView.addSubview(mapButton)
            
            contentView.addSubview(windCloud)
            windCloud.addSubview(windImage)
            windCloud.addSubview(windSpeedValueLabel)
            windCloud.addSubview(windSpeedLable)
            windCloud.addSubview(cloudImage)
            windCloud.addSubview(cloudValueLabel)
            windCloud.addSubview(bottomcloudLabel)
            
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
            
            cityLabel.snp.makeConstraints { make in
                make.top.equalTo(topView.snp.top)
                make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(35)
            }
            
            tempLabel.snp.makeConstraints { make in
                make.top.equalTo(cityLabel.snp.bottom)
                make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(5)
                make.height.equalTo(85)
            }
            
            cloudLabel.snp.makeConstraints { make in
                make.top.equalTo(tempLabel.snp.bottom)
                make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(5)
                make.height.equalTo(20)
            }
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
            
            threetitleImage.snp.makeConstraints { make in
                make.top.equalTo(collectionView.snp.top).offset(-35)
                make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
                make.height.equalTo(35)
                make.width.equalTo(15)
            }
            
            threetitleLabel.snp.makeConstraints { make in
                make.top.equalTo(collectionView.snp.top).offset(-35)
                make.leading.equalTo(threetitleImage).offset(21)
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
            
            mapImage.snp.makeConstraints { make in
                make.top.equalTo(mapView.snp.top).offset(-35)
                make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
                make.height.equalTo(35)
                make.width.equalTo(15)
            }
            
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
            
            cityButton.snp.makeConstraints { make in
                make.top.equalTo(bottonView.safeAreaLayoutGuide).offset(5)
                make.trailing.equalTo(bottonView.safeAreaLayoutGuide).offset(-10)
                make.height.width.equalTo(35)
            }
            
            mapButton.snp.makeConstraints { make in
                make.top.equalTo(bottonView.safeAreaLayoutGuide).offset(5)
                make.leading.equalTo(bottonView.safeAreaLayoutGuide).offset(10)
                make.height.width.equalTo(35)
            }
            
            fivetitleImage.image = UIImage(systemName: "calendar")
            fivetitleImage.tintColor = .white
            fivetitleImage.contentMode = .center
            fivetitleImage.snp.makeConstraints { make in
                make.top.equalTo(tableView.snp.top).offset(-35)
                make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(35)
                make.height.equalTo(35)
                make.width.equalTo(15)
            }
            
            fivetitleLabel.snp.makeConstraints { make in
                make.top.equalTo(tableView.snp.top).offset(-35)
                make.leading.equalTo(threetitleImage).offset(21)
                make.height.equalTo(35)
            }
            
            windCloud.snp.makeConstraints { make in
                make.top.equalTo(mapView.snp.bottom).offset(60)
                make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(35)
                make.height.equalTo(150)
            }
            
            windImage.snp.makeConstraints { make in
                make.top.equalTo(windCloud.safeAreaLayoutGuide)
                make.leading.equalTo(windCloud.safeAreaLayoutGuide)
                make.height.equalTo(35)
            }
            
            windSpeedLable.snp.makeConstraints { make in
                make.top.equalTo(windCloud.safeAreaLayoutGuide)
                make.leading.equalTo(windImage).offset(21)
                make.height.equalTo(35)
                make.width.equalTo(100)
            }
            
            windSpeedValueLabel.snp.makeConstraints { make in
                make.top.equalTo(windSpeedLable.snp.bottom)
                make.leading.equalTo(windCloud.safeAreaLayoutGuide)
                make.width.equalTo(158)
            }
            
            cloudImage.snp.makeConstraints { make in
                make.top.equalTo(windCloud.safeAreaLayoutGuide)
                make.trailing.equalTo(windCloud.safeAreaLayoutGuide).offset(-140)
                make.height.equalTo(35)
            }
            
            bottomcloudLabel.snp.makeConstraints { make in
                make.top.equalTo(windCloud.safeAreaLayoutGuide)
                make.leading.equalTo(cloudImage).offset(21)
                make.height.equalTo(35)
                make.width.equalTo(80)
            }
            
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
            
            barometerImage.snp.makeConstraints { make in
                make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.height.equalTo(35)
            }
            
            barometerLabel.snp.makeConstraints { make in
                make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.leading.equalTo(barometerImage).offset(21)
                make.height.equalTo(35)
                make.width.equalTo(100)
            }
            
            barometerValueLabel.snp.makeConstraints { make in
                make.top.equalTo(barometerLabel.snp.bottom)
                make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.width.equalTo(150)
            }
            
            barometerUnitLabel.snp.makeConstraints { make in
                make.top.equalTo(barometerValueLabel.snp.bottom)
                make.leading.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.width.equalTo(50)
            }
            
            humidityImage.snp.makeConstraints { make in
                make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.trailing.equalTo(barometerHumidity.safeAreaLayoutGuide).offset(-140)
                make.height.equalTo(35)
            }
            
            humidityLabel.snp.makeConstraints { make in
                make.top.equalTo(barometerHumidity.safeAreaLayoutGuide)
                make.leading.equalTo(humidityImage).offset(21)
                make.height.equalTo(35)
                make.width.equalTo(80)
            }
            
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
    
    extension MainViewController : UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.id, for: indexPath) as! MainTableViewCell
            let data = viewmodel.OuputWheatherData.value?.list[indexPath.row]
            let days = viewmodel.OutputdaysDateListData.value
            guard var days = days, indexPath.row < days.count  else { return UITableViewCell() }
            
            if indexPath.row == 0 {
                cell.dayLabel.text = "오늘"
                cell.maxTempLabel.text = "최고 \(viewmodel.OutputFirstTempData.value!.max()!)°"
                cell.minTempLabel.text = "최저 \(viewmodel.OutputFirstTempData.value!.min()!)°"
            }else if indexPath.row == 1 {
                cell.dayLabel.text = "\(days[indexPath.row])"
                cell.maxTempLabel.text = "최고 \(viewmodel.OutputTwoTempData.value!.max()!)°"
                cell.minTempLabel.text = "최저 \(viewmodel.OutputTwoTempData.value!.min()!)°"
            }else if indexPath.row == 2{
                cell.dayLabel.text = "\(days[indexPath.row])"
                cell.maxTempLabel.text = "최고 \(viewmodel.OutputThreeTempData.value!.max()!)°"
                cell.minTempLabel.text = "최저 \(viewmodel.OutputThreeTempData.value!.min()!)°"
            }else if indexPath.row == 3{
                cell.dayLabel.text = "\(days[indexPath.row])"
                cell.maxTempLabel.text = "최고 \(viewmodel.OutputFourTempData.value!.max()!)°"
                cell.minTempLabel.text = "최저 \(viewmodel.OutputFourTempData.value!.min()!)°"
            }else {
                cell.dayLabel.text = "\(days[indexPath.row])"
                cell.maxTempLabel.text = "최고 \(viewmodel.OutputFiveTempData.value!.max()!)°"
                cell.minTempLabel.text = "최저 \(viewmodel.OutputFiveTempData.value!.min()!)°"
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print(indexPath.row)
        }
    }
    
    extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("countcountcountcount", viewmodel.OuputWheatherData.value?.list.count)
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


