//
//  UUDeviceCheckMaicphoneView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//  麦克风检测

import UIKit

class UUDeviceCheckMaicphoneView: UIView {
    
    lazy var bouncedImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var label = UILabel().uu_creatLable(color: "#FFFFFF", font: 15, title: "非常棒，现在请你对我说说话， \n看一下是否有波动？有波动就代表声音正常哦~")
    lazy var leftButton = UUDeviceCheckLeftButton.init(frame: .zero)
    lazy var rightButton = UUDeviceCheckRightButton.init(frame: .zero)
    lazy var logAnimationView = UUSvgaAnimationCenter()
    lazy var leftAnimation = UUSvgaAnimationCenter()
    lazy var rightAnimation = UUSvgaAnimationCenter()
    lazy var vioceLogImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTest_vicoe"))
    lazy var notVioceLogImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_novioceImage"))
    var buttonActionClosure : ((UUDeviceButtonType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfig()
        allAttributeConfig()
        AudioTool.instance.maicphonePlayComplete = {
            self.stopAnimationAndVioce()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func allAttributeConfig() {
        logAnimationView.setSvgaAnimationWithSvgaName(svgaName: "uuCheckDeviceAudio")
        rightAnimation.setSvgaAnimationWithSvgaName(svgaName: "wave")
        leftAnimation.setSvgaAnimationWithSvgaName(svgaName: "wave")
        leftAnimation.svgaPlayer.isHidden = true
        rightAnimation.svgaPlayer.isHidden = true
        vioceLogImageView.isHidden = true
    }
    
    func startAnimationAndVioce(isOk:Bool){
        let source = isOk ? "class_ai_videoOk_maicphone.mp3" : "class_ai_videofaill_maichone.mp3"
        let lableText = isOk ? "非常棒，现在请你对我说说话， \n看一下是否有波动？有波动就代表声音正常哦~":"好的没关系,情况我们已经记录了,现在请你对我说说话， \n看一下是否有波动？有波动就代表声音正常哦~"
        self.label.text = lableText
        AudioTool.instance.playAudio(localUrl: uu_getBundle(forResource: source)!)
        self.logAnimationView.startAnimation()
    }
    
    func stopAnimationAndVioce() {
        AudioTool.instance.stopPlayAudio()
        self.logAnimationView.stopAnimation()
    }
    
    func maiphoneAnimationConfig(isStartAnimation: Bool) {
        self.notVioceLogImageView.isHidden = isStartAnimation
        self.leftAnimation.svgaPlayer.isHidden = !isStartAnimation
        self.rightAnimation.svgaPlayer.isHidden = !isStartAnimation
        self.vioceLogImageView.isHidden = !isStartAnimation
        if isStartAnimation {
            self.rightAnimation.startAnimation()
            self.leftAnimation.startAnimation()
        }else{
            self.rightAnimation.stopAnimation()
            self.leftAnimation.stopAnimation()
        }
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
        
        bouncedImageView.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints { 
            $0.left.equalToSuperview().offset((50))
            $0.top.equalToSuperview().offset((42))
        }
        
        bouncedImageView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-93~)
            $0.bottom.equalToSuperview().offset((-40))
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        leftButton.setTitle("无波动", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        leftButton.setTitleColor(UIColor.color(hexString: "#36AEFF"), for: .normal)
        
        bouncedImageView.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.bottom.size.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview().offset(93~)
        }
        
        rightButton.setTitle("有波动", for: .normal)
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
        
        bouncedImageView.addSubview(notVioceLogImageView)
        notVioceLogImageView.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.left.equalTo(label)
        }
        
        bouncedImageView.addSubview(vioceLogImageView)
        vioceLogImageView.snp.makeConstraints { 
            $0.center.equalTo(notVioceLogImageView)
        }
        
        bouncedImageView.addSubview(leftAnimation.svgaPlayer)
        leftAnimation.svgaPlayer.snp.makeConstraints { 
            $0.centerY.equalTo(vioceLogImageView)
            $0.right.equalTo(vioceLogImageView.snp.left).offset((-3))
            $0.size.equalTo(CGSize(width: (69), height: (32)))
        }
        
        bouncedImageView.addSubview(rightAnimation.svgaPlayer)
        rightAnimation.svgaPlayer.snp.makeConstraints { 
            $0.centerY.equalTo(leftAnimation.svgaPlayer)
            $0.left.equalTo(vioceLogImageView.snp.right).offset((3));
            $0.size.equalTo(leftAnimation.svgaPlayer)
        }
    }
    
}
