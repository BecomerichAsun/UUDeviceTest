//
//  UUDeviceCheckTopView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/21.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

class UUDeviceCheckTopView: UIView {
    
    
    lazy var netLable  = UILabel().uu_creatLable(color: "#FFFFFF", font: 12,title: "网络")
    lazy var netIcon = UIImageView.init(image:uu_image_Bundle(forResource: "uuCheckToolFail"))
    
    lazy var maicphoneLable = UILabel().uu_creatLable(color: "#FFFFFF", font: 12, title: "麦克风")
    lazy var maicphoneIcon = UIImageView.init(image: uu_image_Bundle(forResource: "uuCheckToolFail"))
    
    lazy var videoLale = UILabel().uu_creatLable(color: "#ffffff", font: 12, title: "摄像头")
    lazy var videoIcon = UIImageView.init(image: uu_image_Bundle(forResource: "uuCheckToolFail"))
    
    lazy var speakerLable =  UILabel().uu_creatLable(color: "#ffffff", font: 12, title: "扬声器")
    lazy var speakerIcon = UIImageView.init(image: uu_image_Bundle(forResource: "uuCheckToolFail"))
    
    lazy var speakerTextStateLable = UILabel().uu_normaleCreatLable(color: "#FFFFFF", font: 10, title: "未测试")
    lazy var videoTextStateLable = UILabel().uu_normaleCreatLable(color: "#FFFFFF", font: 10, title: "未测试")
    lazy var maicphoneTextStateLable = UILabel().uu_normaleCreatLable(color: "#FFFFFF", font: 10, title: "未测试")
    lazy var itemW = UIScreen.main.bounds.size.width / 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.color(hexString: "#1a3569")
        uiConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func netCheckResult(title:String,isSuccess: Bool)  {
        self.netLable.text = title
        self.netIcon.image = isSuccess ? uu_image_Bundle(forResource: "uuCheckToolSuccess"): uu_image_Bundle(forResource: "uuCheckToolFail")
    }
    
    func speakerCheckResult(isSuccess: Bool) {
        self.speakerIcon.image = isSuccess ? uu_image_Bundle(forResource: "uuCheckToolSuccess"): uu_image_Bundle(forResource: "uuCheckToolFail")
        self.speakerIcon.isHidden = false
        self.speakerTextStateLable.isHidden = true
        self.speakerTextStateLable.text = "未测试"
    }
    
    func speakerTexting() {
        speakerTextStateLable.text = "测试中..."
    }
    
    func videoTexting() {
        videoTextStateLable.text = "测试中..."
    }
    
    func maicphoneTexting() {
        maicphoneTextStateLable.text = "测试中..."
    }
    
    func videoCheckResult(isSuccess: Bool){
        self.videoIcon.image = isSuccess ? uu_image_Bundle(forResource: "uuCheckToolSuccess"): uu_image_Bundle(forResource: "uuCheckToolFail")
        self.videoIcon.isHidden = false
        self.videoTextStateLable.text = "未测试"
        self.videoTextStateLable.isHidden = true
    }
    
    func maicphoneCheckResult(isSuccess: Bool) {
        self.maicphoneIcon.image = isSuccess ? uu_image_Bundle(forResource: "uuCheckToolSuccess"): uu_image_Bundle(forResource: "uuCheckToolFail")
        self.maicphoneIcon.isHidden = false
        self.maicphoneTextStateLable.text = "未测试"
        self.maicphoneTextStateLable.isHidden = true
    }
}

extension UUDeviceCheckTopView{
    
    func uiConfig() {
        
        speakerIcon.isHidden = true
        maicphoneIcon.isHidden = true
        videoIcon.isHidden = true
        
        self.addSubview(netLable)
        netLable.snp.makeConstraints { 
            $0.centerX.equalTo(self.snp.left).offset(itemW/2)
            $0.centerY.equalToSuperview()
        }
        
        self.addSubview(netIcon)
        netIcon.snp.makeConstraints { 
            $0.left.equalTo(netLable.snp.right).offset(10)
            $0.centerY.equalTo(netLable)
        }
        
        let view0 = UIView()
        view0.backgroundColor = UIColor.color(hexString: "#ffffff",alpha: 0.1)
        self.addSubview(view0)
        view0.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1, height: 10))
            $0.right.equalTo(self.snp.left).offset(itemW)
        }
        
        self.addSubview(speakerLable)
        speakerLable.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(self.snp.left).offset(itemW + itemW/2)
        }
        
        self.addSubview(speakerTextStateLable)
        speakerTextStateLable.snp.makeConstraints { 
            $0.centerY.equalTo(speakerLable)
            $0.left.equalTo(speakerLable.snp.right).offset((10))
        }
        
        self.addSubview(speakerIcon)
        speakerIcon.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.left.equalTo(speakerLable.snp.right).offset(10)
        }
        
        let view1 = UIView()
        view1.backgroundColor = UIColor.color(hexString: "#ffffff",alpha: 0.1)
        self.addSubview(view1)
        view1.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1, height: 10))
            $0.right.equalTo(self.snp.left).offset(2 * itemW)
        }
        
        self.addSubview(videoLale)
        videoLale.snp.makeConstraints { 
            $0.centerX.equalTo(self.snp.left).offset(2*itemW + itemW/2)
            $0.centerY.equalToSuperview()
        }
        self.addSubview(videoTextStateLable)
        videoTextStateLable.snp.makeConstraints { 
            $0.centerY.equalTo(videoLale)
            $0.left.equalTo(videoLale.snp.right).offset((10))
        }
        self.addSubview(videoIcon)
        videoIcon.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.left.equalTo(videoLale.snp.right).offset(10)
        }
        let view2 = UIView()
        view2.backgroundColor = UIColor.color(hexString: "#ffffff",alpha: 0.1)
        self.addSubview(view2)
        view2.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 1, height: 10))
            $0.right.equalTo(self.snp.left).offset(3 * itemW)
        }
        
        self.addSubview(maicphoneLable)
        maicphoneLable.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.centerX.equalTo(self.snp.left).offset(3*itemW + itemW/2)
        }
        self.addSubview(maicphoneTextStateLable)
        maicphoneTextStateLable.snp.makeConstraints { 
            $0.centerY.equalTo(maicphoneLable)
            $0.left.equalTo(maicphoneLable.snp.right).offset((10))
        }
        self.addSubview(maicphoneIcon)
        maicphoneIcon.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.left.equalTo(maicphoneLable.snp.right).offset(10)
        }
        
    }
}


extension UILabel{
    
    func uu_creatLable(color: String,font: CGFloat, title: String) -> UILabel {
        let lable = UILabel.init()
        lable.textColor = UIColor.color(hexString: color)
        lable.font = UIFont.init(name: "PingFang-SC-Medium", size: font~)
        lable.text = title
        return lable
    }
    
    func uu_normaleCreatLable(color: String,font: CGFloat, title: String) -> UILabel {
        let lable = UILabel.init()
        lable.textColor = UIColor.color(hexString: color)
        lable.font = UIFont.systemFont(ofSize: font~)
        lable.text = title
        return lable
    }
}
