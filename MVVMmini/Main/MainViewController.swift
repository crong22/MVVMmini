//
//  MainViewController.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import SnapKit

class MainViewController : UIViewController {
    let topView = UIView()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let cloudLabel = UILabel()
    let maxmintempLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    let tableView = UITableView()
    //model선언
    let viewmodel = MainViewModel()
    
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
        
        viewmodel.OuputWheatherData.bind { value in
            self.collectionView.reloadData()
        }
        
        viewmodel.OuputCurrentWheatherData.bind { data in
            // city
            self.cityLabel.text = data?.name
            
            // temp
            guard var temp = data?.main.temp  else { return }
            temp = temp - 273.15
            let num = String(format: "%.1f", temp)
            self.tempLabel.text = num + "°"
            
            // clouds
            guard let cloudname = data?.weather.first?.description else { return }
            self.cloudLabel.text = cloudname
            
            // max temp , min temp
            guard var max = data?.main.temp_max  else { return }
            max = max - 273.15
            let maxtemp = String(format: "%.1f", max)
            guard var min = data?.main.temp_max  else { return }
            min = min - 273.15
            let mintemp = String(format: "%.1f", min)
            self.maxmintempLabel.text = "최고 :" + maxtemp + " | " + "최저 :" + mintemp
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
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
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
            make.leading.equalTo(topView.safeAreaLayoutGuide).offset(105)
            make.height.equalTo(85)
        }
        
        cloudLabel.text = "Broken clouds"
        cloudLabel.textColor = .white
        cloudLabel.textAlignment = .center
        cloudLabel.font = .systemFont(ofSize: 20, weight: .bold)
        cloudLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(20)
        }
        
        maxmintempLabel.text = "최고 :7.0° | 최저 :-4.2°"
        maxmintempLabel.textColor = .white
        maxmintempLabel.textAlignment = .center
        maxmintempLabel.font = .systemFont(ofSize: 20, weight: .bold)
        maxmintempLabel.snp.makeConstraints { make in
            make.top.equalTo(cloudLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(topView.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.height.equalTo(400)
        }
        
    }
    
    func configureView() {
        view.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 255/255, alpha: 0.8)
        collectionView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 255/255, alpha: 0.3)
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
        return cell
    }
    
    
}

extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.id, for: indexPath) as! MainCollectionViewCell
//        let data = viewmodel.OuputWheatherData.value![indexPath.row]
        print("collection \(viewmodel.OuputWheatherData.value)")
        
        return cell
    }
    
    
}
