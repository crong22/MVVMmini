//
//  FindTableViewCell.swift
//  MVVMmini
//
//  Created by 여누 on 7/13/24.
//

import UIKit
import SnapKit

class FindTableViewCell : UITableViewCell {
    
    static let id = "FindTableViewCell"
    
    let mainLabel = UILabel()
    let cityLabel = UILabel()
    let countryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .black
        
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
    }
    
    func configureLayout() {
        
        mainLabel.text = "#"
        mainLabel.textColor = .white
        mainLabel.textAlignment = .left
        mainLabel.font = .systemFont(ofSize: 28, weight: .regular)
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(5)
        }
        
        cityLabel.text = "Seoul"
        cityLabel.textColor = .white
        cityLabel.textAlignment = .left
        cityLabel.font = .systemFont(ofSize: 16, weight: .regular)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.leading.equalTo(mainLabel.safeAreaLayoutGuide).offset(23)
        }
        
        countryLabel.text = "KR"
        countryLabel.textColor = .white
        countryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        countryLabel.textAlignment = .left
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.leading.equalTo(mainLabel.safeAreaLayoutGuide).offset(23)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
