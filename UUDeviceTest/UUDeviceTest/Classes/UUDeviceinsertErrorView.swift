//
//  UUDeviceCheckVideoView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//  摄像头检测

import UIKit

class UUDeviceinsertErrorView: UIView {
    
    lazy var bouncedImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var label = UILabel().uu_creatLable(color: "#FFFFFF", font: 15, title: "好像有点小问题，不要担心， \n先和我一起完成全部检查~！")
    lazy var nextButton = UUDeviceCheckRightButton.init(frame: .zero)
    lazy var logAnimationView = UUSvgaAnimationCenter()
    
    var buttonActionClosure : ((UUDeviceButtonType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfig()
        logAnimationView.setSvgaAnimationWithSvgaName(svgaName: "uuCheckDeviceInsert")
        AudioTool.instance.maicphonePlayComplete = {
            self.stopAnimationAndVioce()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimationAndVioce(){
        AudioTool.instance.playAudio(localUrl: uu_getBundle(forResource: "check_ai_insert_fail.mp3")!)
        self.logAnimationView.startAnimation()
    }
    
    func stopAnimationAndVioce() {
        AudioTool.instance.stopPlayAudio()
        self.logAnimationView.stopAnimation()
    }
    
    func uiConfig()  {
        
        self.addSubview(bouncedImageView)
        bouncedImageView.isUserInteractionEnabled = true
        bouncedImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: screenScale(519~), height: 268~))
            $0.right.equalToSuperview().offset(screenScale(-37~))
            $0.centerY.equalToSuperview()
        }
        
        bouncedImageView.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints {
            $0.top.equalToSuperview().offset((42))
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        bouncedImageView.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset((-45))
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        
        nextButton.setTitle("知道了", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        self.addSubview(logAnimationView.svgaPlayer)
        logAnimationView.svgaPlayer.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: (isDevicePlus == false ? 369 : screenScale(369)*0.8), height: (isDevicePlus == false ? 400 : screenScale(400)*0.8)))
        }
    }
    
    @objc func nextButtonAction() {
        if let closure = buttonActionClosure {
            self.stopAnimationAndVioce()
            closure(.left)
        }
    }
}
