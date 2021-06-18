//
//  UUDeviceCheckVideoView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//  摄像头检测

import UIKit

class UUDeviceCheckVideoView: UIView {
    
    lazy var bouncedImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var label = UILabel().uu_creatLable(color: "#FFFFFF", font: 15, title: "很棒哦~下面显示你的头像,\n你能看见画面吗？")
    lazy var leftButton = UUDeviceCheckLeftButton.init(frame: .zero)
    lazy var rightButton = UUDeviceCheckRightButton.init(frame: .zero)
    lazy var logAnimationView = UUSvgaAnimationCenter()
    lazy var crownAnimationView = UUSvgaAnimationCenter()
    lazy var videoView = UUDeviceVideoView()
    
    var buttonActionClosure : ((UUDeviceButtonType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfig()
        allAttributeConfig()
        AudioTool.instance.videoPlayComplete = {
            self.stopAnimationAndVioce()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func allAttributeConfig() {
        logAnimationView.setSvgaAnimationWithSvgaName(svgaName: "UUDeviceCheckVideo")
        crownAnimationView.setSvgaAnimationWithSvgaName(svgaName: "dcl_ai_device_check_arrow_r")
        crownAnimationView.startAnimation()
    }
    
    func startAnimationAndVioce(isOk: Bool){
        let source = isOk ? "class_ai_video.mp3":"speaker_fail_video.mp3"
        self.label.text = isOk ? "很棒哦~旁边显示你的头像,\n你能看见画面吗？": "好的没关系!情况我们已经记录了,旁边显示你的头像,\n你能看见画面吗?"
        AudioTool.instance.playAudio(localUrl: uu_getBundle(forResource: source)!)
        self.logAnimationView.startAnimation()
    }
    
    func stopAnimationAndVioce() {
        AudioTool.instance.stopPlayAudio()
        self.logAnimationView.stopAnimation()
    }
    
    
    @objc func leftButtonAction(){
        if self.buttonActionClosure != nil {
            self.buttonActionClosure!(.left)
            self.stopAnimationAndVioce()
        }
    }
    
    @objc func rightButtonAction(){
        if self.buttonActionClosure != nil {
            self.buttonActionClosure!(.right)
            self.stopAnimationAndVioce()
        }
    }
    
    func uiConfig()  {
        
        self.addSubview(bouncedImageView)
        bouncedImageView.isUserInteractionEnabled = true
        bouncedImageView.snp.makeConstraints { 
            $0.size.equalTo(CGSize(width: screenScale(519~), height: 268~))
            $0.right.equalToSuperview().offset(screenScale(-37~))
            $0.centerY.equalToSuperview()
        }
        
        bouncedImageView.addSubview(videoView)
        videoView.layer.cornerRadius = 3.3
        videoView.layer.masksToBounds = true
        videoView.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        videoView.isHidden = true
        videoView.snp.makeConstraints{
            $0.size.equalTo(CGSize(width: 135~, height: 83~))
            $0.right.equalTo(bouncedImageView.snp.right).offset(-32)
            $0.top.equalTo(31)
        }
        self.videoView.setNeedsLayout()
        self.videoView.layoutIfNeeded()
        
        bouncedImageView.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints { 
            $0.left.equalToSuperview().offset((50))
            $0.top.equalToSuperview().offset((42))
            $0.right.equalTo(videoView.snp.left).offset(-20)
        }
        
        bouncedImageView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-93~)
            $0.bottom.equalToSuperview().offset((-40))
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        
        leftButton.setTitle("看不见", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        leftButton.setTitleColor(UIColor.color(hexString: "#36AEFF"), for: .normal)
        
        bouncedImageView.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.bottom.size.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview().offset(93~)
        }
        
        rightButton.setTitle("看得见", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        rightButton.setTitleColor(UIColor.color(hexString: "#FFFFFF"), for: .normal)
        
        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        
        self.addSubview(logAnimationView.svgaPlayer)
        logAnimationView.svgaPlayer.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: (isDevicePlus == false ? 369 : screenScale(369)*0.8), height: (isDevicePlus == false ? 400 : screenScale(400)*0.8)))
        }
        
        bouncedImageView.addSubview(crownAnimationView.svgaPlayer)
        crownAnimationView.svgaPlayer.snp.makeConstraints { 
            $0.centerY.equalTo(videoView).offset(20)
            $0.right.equalTo(videoView.snp.left).offset((-20))
            $0.size.equalTo(CGSize(width: (40), height: (30)))
        }
    }
}
