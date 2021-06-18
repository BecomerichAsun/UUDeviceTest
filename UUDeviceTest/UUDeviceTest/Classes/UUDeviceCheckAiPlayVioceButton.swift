//
//  UUDeviceCheckAiPlayVioceButton.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/21.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

enum UUPlayType{
    case startPlay
    case pasuePlay
    case rePlay
}

class UUDeviceCheckAiPlayVioceButton: UIButton {
    
    
    lazy var vioceImageView =  UIImageView.init(image:uu_image_Bundle(forResource: "aiTestImage_vioceImage"))
    lazy var voiceSvgaAnimationCenter = UUSvgaAnimationCenter()
    var logAnimationCenter : UUSvgaAnimationCenter?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        uiConfig()
        
        AudioTool.instance.speakerPlayComplete = {
            self.setTitle("重新播放", for: .normal)
            self.stopAnimation()
        }
        voiceSvgaAnimationCenter.setSvgaAnimationWithSvgaName(svgaName: "uuCheckDeviceVoice")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///state 0 开始播放 1 暂停播放 2r重新播放
    func setAiPlayVioceButtonState(statue:UUPlayType ){
        
        switch statue {
        case .startPlay:
            AudioTool.instance.playAudio(localUrl: uu_getBundle(forResource: "startTest.mp3")!)
            self.setTitle("暂停播放", for: .normal)
            self.startAnimation()
            break
        case .pasuePlay:
            self.setTitle("继续播放", for: .normal)
            AudioTool.instance.pausePlayAudio()
            self.stopAnimation()
            break
        case .rePlay:
            setTitle("暂停播放", for: .normal)
            AudioTool.instance.continueToPlay()
            self.startAnimation()
            break
        }
    }
    
    func startAnimation()  {
        voiceSvgaAnimationCenter.startAnimation()
        self.vioceImageView.isHidden = true
        self.voiceSvgaAnimationCenter.svgaPlayer.isHidden = false
        self.logAnimationCenter?.startAnimation()
    }
    
    func stopAnimation() {
        voiceSvgaAnimationCenter.stopAnimation()
        self.logAnimationCenter?.stopAnimation()
        self.vioceImageView.isHidden = false
        self.voiceSvgaAnimationCenter.svgaPlayer.isHidden = true
    }
    
    func uiConfig() {
        self.setBackgroundImage(uu_image_Bundle(forResource: "uuplayBtn"), for: .normal)
        self.addSubview(vioceImageView)
        self.vioceImageView.snp.makeConstraints { 
            $0.left.equalTo(self).offset(19)
            $0.centerY.equalTo(self)
        }
        
        self.addSubview(voiceSvgaAnimationCenter.svgaPlayer)
        voiceSvgaAnimationCenter.svgaPlayer.snp.makeConstraints { 
            $0.left.equalTo(self).offset(19)
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(14)
        }
        
        self.setTitleColor(UIColor.color(hexString: "#FFFFFF"), for: .normal)
        self.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 13~)
        
    }
}
