//
//  FindViewController.swift
//  MVVMmini
//
//  Created by 여누 on 7/13/24.
//

import UIKit
import SnapKit

class FindViewController : UIViewController {
        
    let titleLabel = UILabel()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var cityList: [city] = []
    
//    let findmodel = FindViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCities()
    
        configureHierarchy()
        configureLayout()
        configureView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(FindTableViewCell.self, forCellReuseIdentifier: FindTableViewCell.id)
        
    }
    

    private func loadCities() {
        guard let url = Bundle.main.url(forResource: "CityList", withExtension: "json") else {
            print("JSON 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            cityList = try decoder.decode([city].self, from: data)
            tableView.reloadData()
        } catch {
            print("JSON 데이터를 파싱하는 중 오류가 발생했습니다: \(error)")
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        titleLabel.text = "CITY"
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.layer.cornerRadius = 5
        searchBar.barTintColor = .black
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = .orange
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
//    private func bindata() {
//        findmodel.inputViewDidLoadTrigger.value = ()
//        print("1")
//        findmodel.inputCityData.bind { value in
//            print("value", value)
//            self.findmodel.outPutCityData.value = value
//        }
//    }
}

extension FindViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindTableViewCell.id, for: indexPath) as! FindTableViewCell
        print(cityList.first?.name)
        let data = cityList[indexPath.row]
        cell.cityLabel.text = data.name
        cell.countryLabel.text = "KR"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭")
        //        findmodel.inputCityData.value = cityList[indexPath.row]
        //        bindata()
        let selectcity = cityList[indexPath.row]
        let vc = MainViewController()
        vc.city = selectcity
//        if let window = UIApplication.shared.windows.first {
//            window.rootViewController = vc
//            window.makeKeyAndVisible()
        present(vc, animated: true)
        }
        
    }

