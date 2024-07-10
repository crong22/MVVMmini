//
//  MainTableViewCell.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import SnapKit

class MainTableViewCell : UITableViewCell {
    
    static let id = "MainTableViewCell"
    
    let dayLabel = UILabel()
    let weatherImage = UIImageView()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    

    
    func configureHierarchy() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
    }
    
    func configureLayout() {
        contentView.backgroundColor = .brown
        
        dayLabel.text = "오늘"
        dayLabel.textColor = .black
        dayLabel.font = .systemFont(ofSize: 24, weight: .regular)
        dayLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(3)
            make.height.equalTo(50)
        }
        
//        weatherImage.backgroundColor = .cyan
        weatherImage.image = UIImage(systemName: "heart")
        weatherImage.contentMode  = .scaleAspectFill
        weatherImage.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(100)
        }
        
//        minTempLabel.backgroundColor = .black
        minTempLabel.textColor = .lightGray
        minTempLabel.font = .systemFont(ofSize: 18, weight: .regular)
        minTempLabel.textAlignment = .left
        minTempLabel.text = "최저 -2°"
        minTempLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(150)
            make.height.equalTo(30)
        }
        
//        maxTempLabel.backgroundColor = .purple
        maxTempLabel.textColor = .white
        maxTempLabel.font = .systemFont(ofSize: 18, weight: .regular)
        maxTempLabel.text = "최고 9°"
        maxTempLabel.textAlignment = .right
        maxTempLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(3)
            make.height.equalTo(30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
