//
//  MainCollectionViewCell.swift
//  MVVMmini
//
//  Created by 여누 on 7/10/24.
//

import UIKit
import SnapKit

class MainCollectionViewCell : UICollectionViewCell {
    
    static let id = "MainCollectionViewCell"

    let mainView = UIView()
    let timeLabel = UILabel()
    let cloudImage = UIImageView()
    let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(mainView)
        mainView.addSubview(timeLabel)
        mainView.addSubview(cloudImage)
        mainView.addSubview(tempLabel)
        

        mainView.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 255/255, alpha: 0)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.bottom.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        timeLabel.text = "12시"
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(mainView.safeAreaLayoutGuide).offset(10)
        }
        
        tempLabel.text = "24°"
        tempLabel.textColor = .white
        tempLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tempLabel.snp.makeConstraints { make in
            make.bottom.equalTo(mainView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(mainView.safeAreaLayoutGuide).offset(11)
        }
        
        cloudImage.image = UIImage(systemName: "star")
        cloudImage.contentMode = .scaleAspectFit
        cloudImage.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.leading.equalTo(mainView.safeAreaLayoutGuide).offset(8)
            make.height.width.equalTo(45)
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
