//
//  UUDeviceCheckErrorCollectionCell.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

class UUDeviceCheckErrorCollectionCell: UICollectionViewCell {
    
    
    
    lazy var iconImageView = UIImageView()
    lazy var titleLable = UILabel().uu_creatLable(color: "#FFFFFF", font: 15, title: "")
    lazy var errorLable = UILabel().uu_creatLable(color: "#FE6667", font: 15, title: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        uiConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setErrorItemModel(model:UUDeviceCheckItmeModel) {
        
        self.iconImageView.image = uu_image_Bundle(forResource: model.icon)
        self.titleLable.text = model.title
        self.errorLable.text = "异常>"
    }
    
    func uiConfig() {
        
        self.titleLable.textAlignment = .left
        self.errorLable.textAlignment = .left
        self.contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(22)
            $0.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.right).offset((2))
        }
        
        self.contentView.addSubview(errorLable)
        errorLable.snp.makeConstraints {
            $0.centerY.equalTo(titleLable)
            $0.left.equalTo(titleLable.snp.right).offset((10))
        }
    }
}
