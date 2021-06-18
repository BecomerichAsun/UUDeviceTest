//
//  UUDeviceCheckSuccessView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

class UUDeviceCheckSuccessView: UIView {
    
    lazy var backgroundImageView = UIImageView.init(image:uu_image_Bundle(forResource: "UUCheckBackground"))
    lazy var contentImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var resultButton = UUDeviceCheckRightButton.init(frame: .zero)
    
    var exitClosure : (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfig()
    }
    
    func startPalyVioce() {
        AudioTool.instance.playAudio(localUrl:uu_getBundle(forResource: "class_result_fine.mp3")!)
    }
    
    @objc func resultButtonAction(){
        if self.exitClosure != nil {
            self.exitClosure!()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func uiConfig() {
        
        self.isUserInteractionEnabled = true
        backgroundImageView.isUserInteractionEnabled = true
        contentImageView.isUserInteractionEnabled = true
        
        self.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        backgroundImageView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints { 
            $0.size.equalTo(CGSize(width: screenScale(519~), height: 268~))
            $0.right.equalToSuperview().offset(screenScale(-37~))
            $0.centerY.equalToSuperview()
        }
        
        let label = UILabel().uu_creatLable(color: "#FFFFFF", font: 16, title: "太棒啦~！所有的自主调试课的检测全部通过了~ \n可以准备安心上课，和我一起开启学霸之路~")
        label.numberOfLines = 0
        label.textAlignment = .center
        contentImageView.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        resultButton.setTitle("退出设备检测", for: .normal)
        resultButton.setTitleColor(UIColor.color(hexString: "#FFFFFF"), for: .normal)
        resultButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        resultButton.addTarget(self, action: #selector(resultButtonAction), for: .touchUpInside)
        contentImageView.addSubview(resultButton)
        resultButton.snp.makeConstraints { 
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-40)
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        
        let iconImage = UIImageView.init(image: uu_image_Bundle(forResource: "uuaitestpass"))
        backgroundImageView.addSubview(iconImage)
        iconImage.snp.makeConstraints { 
            $0.centerY.equalTo(contentImageView).offset(40)
            $0.right.equalTo(contentImageView.snp.left).offset(screenScale(40))
            $0.size.equalTo(CGSize(width: isDevicePlus == false ? screenScale(273~) : screenScale(273~)*0.8, height: isDevicePlus == false ? 283~ : 0.8*283~))
        }
    }
}
