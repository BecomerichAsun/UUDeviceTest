//
//  UUSvgaAnimationCenter.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/21.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit
import SVGAPlayer

class UUSvgaAnimationCenter: NSObject {
    
    lazy var svgaPlayer = SVGAPlayer()
    
    override init() {
        super.init()
        svgaPlayer.clearsAfterStop = false
    }
    
    func startAnimation() {
        self.svgaPlayer.startAnimation()
    }
    
    func stopAnimation() {
        self.svgaPlayer.stopAnimation()
    }
    
    func setSvgaAnimationWithSvgaName(svgaName: String)  {
        if svgaName.isEmpty {
            return
        }
        
        let parser = SVGAParser()
        parser.parse(withNamed: svgaName, in: uu_checkBundle(), completionBlock: { (videoItem) in
            self.svgaPlayer.videoItem = videoItem
            self.svgaPlayer.startAnimation()
        }) { (_) in
        }
    }
}
