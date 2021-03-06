//
//  UUMacroFle.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/21.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import Foundation

public let ScreenScale = UIScreen.main.bounds.size.width / 779

public let isDevicePlus: Bool = UIDevice.current.deviceEqualPlus || UIDevice.current.deviceEqual667 || UIDevice.current.deviceEqualSE

public let isDeviceEuqal667: Bool = UIDevice.current.deviceEqual667

public let isDeviceEqualSE: Bool = UIDevice.current.deviceEqualSE

func screenScale(_ input: CGFloat) -> CGFloat {
    if isDevicePlus {
        return 736/812*input
    }
    if isDeviceEuqal667 {
        return 667/812*input
    }
    if isDeviceEqualSE {
        return 568/812*input
    }
        return input
}



func uu_getBundle(forResource: String?) -> String? {
    let sdkbundle = Bundle.init(for: UUDeviceCheckController.self)
    let bundlePath = sdkbundle.url(forResource: "UUCheckSources", withExtension: "bundle")
    let relBundle = Bundle.init(url: bundlePath!)
    return relBundle?.path(forResource: forResource, ofType: nil)
}

func uu_checkBundle() -> Bundle {
    let sdkbundle =  Bundle.init(for: UUDeviceCheckController.self)
    let bundlePath = sdkbundle.url(forResource: "UUCheckSources", withExtension: "bundle")
    let relBundle = Bundle.init(url: bundlePath!)
    return relBundle!
}

func uu_image_Bundle(forResource: String?) -> UIImage{
    let sdkbundle =  Bundle.init(for: UUDeviceCheckController.self)
    let bundlePath = sdkbundle.url(forResource: "UUCheckSources", withExtension: "bundle")
    let relBundle = Bundle.init(url: bundlePath!)
    var scale:Int = Int(UIScreen.main.scale)
    if scale > 2 {scale = 3} else {scale = 2}
    let imageUrl = relBundle?.path(forResource: forResource! + "@" + String(scale) + "x.png" , ofType: nil)
    return UIImage(contentsOfFile: imageUrl!)!
}


extension UIDevice {
    
    var deviceEqualPlus: Bool {
        get {
            return self.deviceVersionName.elementsEqual("iPhone 6 Plus") || self.deviceVersionName.elementsEqual("iPhone 8 Plus") ||
                self.deviceVersionName.elementsEqual("iPhone 7 Plus")
        }
    }
    
    var deviceEqual667: Bool {
        get {
            return self.deviceVersionName.elementsEqual("iPhone 6") || self.deviceVersionName.elementsEqual("iPhone 6s") ||
                self.deviceVersionName.elementsEqual("iPhone 7") ||
                self.deviceVersionName.elementsEqual("iPhone 8")
        }
    }
    
    var deviceEqualSE: Bool {
        get {
            return self.deviceVersionName.elementsEqual("iPhone SE") ||
                self.deviceVersionName.elementsEqual("iPhone 5") ||
                self.deviceVersionName.elementsEqual("iPhone 5s") ||
                self.deviceVersionName.elementsEqual("iPhone 5c")
        }
    }
    
    /// 获取设备具体详细的型号
    var deviceVersionName: String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {return identifier}
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":
            return "iPod Touch 1G"
        case "iPod2,1":
            return "iPod Touch 2G"
        case "iPod3,1":
            return "iPod Touch 3G"
        case "iPod4,1":
            return "iPod Touch 4G"
        case "iPod5,1":
            return "iPod Touch 5G"
        case "iPod7,1":
            return "iPod Touch 6G"
            
        case "iPhone1,1":
            return "iPhone 2G"
        case "iPhone1,2":
            return "iPhone 3G"
        case "iPhone2,1":
            return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"
            
        case "iPhone5,1":
            return "iPhone 5"
        case "iPhone5,2":
            return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":
            return "iPhone 5c (GSM)"
        case "iPhone5,4":
            return "iPhone 5c (GSM+CDMA)"
            
        case "iPhone6,1":
            return "iPhone 5s (GSM)"
        case "iPhone6,2":
            return "iPhone 5s (GSM+CDMA)"
            
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
            
        case "iPhone8,4":
            return "iPhone SE"
            /// "国行、日版、港行iPhone 7"
        case "iPhone9,1":
            return "iPhone 7"
            /// "港行、国行iPhone 7 Plus"
        case "iPhone9,2":
            return "iPhone 7 Plus"
            /// "美版、台版iPhone 7"
        case "iPhone9,3":
            return "iPhone 7"
            /// "美版、台版iPhone 7 Plus"
        case "iPhone9,4":
            return "iPhone 7 Plus"
            
        case "iPhone10,1":
            return "iPhone 8"
        case "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2":
            return "iPhone 8 Plus"
        case "iPhone10,5":
            return "iPhone 8 Plus"
            
        case "iPhone10,3":
            return "iPhone X"
        case "iPhone10,6":
            return "iPhone X"
            
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
 
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
    
            
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12  Pro"
        case "iPhone13,4":
            return "iPhone 12  Pro Max"
            
        case "iPad1,1":
            return "iPod Touch 1G"
        case "iPad1,2":
            return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return "iPod Touch 2G"
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return "iPad Mini 1G"
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":
            return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":
            return "iPad Air 2"
        case "iPad6,3", "iPad6,4":
            return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":
            return "iPad Pro 12.9"
            
        case "AppleTV2,1":
            return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2":
            return "Apple TV 3"
        case "AppleTV5,3":
            return "Apple TV 4"
            
        case "i386", "x86_64":
            return "iPhone 11 Pro"
            
        default:
            return "iPhone"
        }
    }
}
