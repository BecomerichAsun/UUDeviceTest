//
//  UUDeviceCheckMaicphoneView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/21.
//  Copyright © 2020 xiananwu. All rights reserved.
// 扬声器检测

import UIKit
import SnapKit

enum UUDeviceButtonType{
    case left
    case right
}

class UUDeviceCheckSpeakerView: UIView {
    lazy var bouncedImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var label = UILabel().uu_creatLable(color: "#FFFFFF", font: 15, title: "Hi~~我是学霸张！为了保证更好的上课体验， 我将带你一起检测设备！现在让我们开始吧~ 你能听见我的声音吗？")
    lazy var aiPlayVioceButton = UUDeviceCheckAiPlayVioceButton()
    lazy var leftButton = UUDeviceCheckLeftButton.init(frame: .zero)
    lazy var rightButton = UUDeviceCheckRightButton.init(frame: .zero)
    lazy var logAnimationView = UUSvgaAnimationCenter()
    
    var buttonActionClosure : ((UUDeviceButtonType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        label.numberOfLines = 0
        self.backgroundColor = .clear
        allAttributeConfig()
        uiConfig()
        aiPlayVioceButtonConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func allAttributeConfig() {
        logAnimationView.setSvgaAnimationWithSvgaName(svgaName: "UUCheckDeviceSpeaker")
    }
    
    @objc func aiPlayVioceButtonAction(send: UIButton){
        
        if AudioTool.instance.player?.isPlaying ?? false {
            self.aiPlayVioceButton.setAiPlayVioceButtonState(statue: .pasuePlay)
        }else{
            self.aiPlayVioceButton.setAiPlayVioceButtonState(statue: .rePlay)
        }
    }
    
    @objc func leftButtonAction(){
        if self.buttonActionClosure != nil {
            self.buttonActionClosure!(.left)
        }
    }
    
    @objc func rightButtonAction(){
        if self.buttonActionClosure != nil {
            self.buttonActionClosure!(.right)
        }
    }
    
    func aiPlayVioceButtonConfig() {
        aiPlayVioceButton.addTarget(self, action: #selector(aiPlayVioceButtonAction), for: .touchUpInside)
        self.aiPlayVioceButton.logAnimationCenter = logAnimationView
        AudioTool.instance.stopPlayAudio()
        self.aiPlayVioceButton.setAiPlayVioceButtonState(statue: .startPlay)
        
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
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset((50))
            $0.top.equalToSuperview().offset((41))
            $0.right.equalToSuperview().offset((-174))
        }
        
        bouncedImageView.addSubview(aiPlayVioceButton)
        aiPlayVioceButton.snp.makeConstraints {
            $0.left.equalTo(label)
            $0.top.equalTo(label.snp.bottom).offset((20~))
        }
        
        bouncedImageView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-93~)
            $0.bottom.equalToSuperview().offset((-40))
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        leftButton.setTitle("听不见", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
        leftButton.setTitleColor(UIColor.color(hexString: "#36AEFF"), for: .normal)
        
        bouncedImageView.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.bottom.size.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview().offset(93~)
        }
        
        rightButton.setTitle("听得见", for: .normal)
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
    }
}
class UUDeviceCheckLeftButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(uu_image_Bundle(forResource: "aiTestImage_left"), for: .normal)
        self.setTitleColor(UIColor.color(hexString: "#36AEFF"), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UUDeviceCheckRightButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundImage(uu_image_Bundle(forResource: "aiTestImage_right"), for: .normal)
        self.setTitleColor(UIColor.color(hexString: "#FFFFFF"), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14~)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

