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
    var filterCityList: [city] = []

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
        
        searchBar.delegate = self

        filterCityList = cityList
        
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
            filterCityList = cityList
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

}

extension FindViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FindTableViewCell.id, for: indexPath) as! FindTableViewCell
        let data = filterCityList[indexPath.row]
        cell.cityLabel.text = data.name
        cell.countryLabel.text = "KR"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭")

        let selectcity = filterCityList[indexPath.row]
        let vc = MainViewController()
        vc.city = selectcity
        print(selectcity)
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true, completion: nil)
    }
        
}

extension FindViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterCityList = cityList
        } else {
            filterCityList = cityList.filter { $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            tableView.reloadData()
        }
        
    }

