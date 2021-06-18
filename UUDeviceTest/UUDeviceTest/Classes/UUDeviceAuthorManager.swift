//
//  UUDeviceAuthorManager.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/20.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit
import AVFoundation

enum UUDeviceCheckType{
    case video
    case audio
}

@objcMembers open class UUDeviceAuthorManager: NSObject {
    
    var showUserGotoSetOpenAuthorClosure : ((UUDeviceCheckType) -> ())?
    var authorSuccessClosure : (()->())?
    
    
    open func checkUserAuthorIsOpen(){
        checkCameraAuthorStatus()
    }
    
    ///检查相机是否授权
    open func checkCameraAuthorStatus(){
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            self.checkMicrophoneAuthorStatus()
            break
        default:
            self.openCameraAuthor()
            break
        }
    }
    ///开启相机权限
    open func openCameraAuthor() {
        AVCaptureDevice.requestAccess(for: .video) { (isOpen) in
            DispatchQueue.main.async {
                if isOpen {
                    self.checkMicrophoneAuthorStatus()
                }else{
                    if self.showUserGotoSetOpenAuthorClosure != nil {
                        self.showUserGotoSetOpenAuthorClosure!(UUDeviceCheckType.video)
                    }
                }
            }
        }
    }
    
    ///检查麦克风权限
    open func checkMicrophoneAuthorStatus() {
        
        
        let status =  AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            guard let finshClosure = self.authorSuccessClosure else {
                return
            }
            finshClosure()
            break
        default:
            self.openMaicphoneAuthor()
            break
        }
    }
    
    open func openMaicphoneAuthor(){
        AVCaptureDevice.requestAccess(for:.audio) { (isOpen) in
            DispatchQueue.main.async {
                if isOpen {
                    guard let finshClosure = self.authorSuccessClosure else {
                        return
                    }
                    finshClosure()
                }else{
                    guard let gotoSetOpenClosure = self.showUserGotoSetOpenAuthorClosure else {
                        return
                    }
                    gotoSetOpenClosure(.audio)
                }
            }
        }
    }
    
}
