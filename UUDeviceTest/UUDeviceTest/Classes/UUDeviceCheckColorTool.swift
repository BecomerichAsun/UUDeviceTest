//
//  UUDeviceCheckColorTool.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/20.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

extension UIColor{
    
    ///十六进制字符串转颜色
    static func color(hexString:String)->UIColor{
        return self.color(hexString: hexString, alpha: 1.0)
    }
    
    ///十六进制字符串转颜色
    static func color(hexString:String,alpha:CGFloat)->UIColor{
        let (r,g,b) = hexStringToColorValue(hexString: hexString)
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    ///十进制数转颜色
    static func color(decNum:Int)->UIColor{
        return color(hexString: String(decNum,radix:16))
    }
    
    static func rgbColor(rgbValue: Int) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func randomColor() -> UIColor {
        let hue = ( CGFloat(arc4random() % 256) / 256.0 );  //  0.0 to 1.0
        let saturation = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        let brightness = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        return UIColor.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    /// SwifterSwift: Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    @objc  convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    
    
    /// SwifterSwift: Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    @objc  convenience init(hexString: String) {
        self.init(hexString: hexString, transparency: 1)
    }
    
    /// SwifterSwift: Create Color from hexadecimal string with optional transparency (if applicable).
    ///
    /// - Parameters:
    ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
    ///   - transparency: optional transparency value (default is 1).
    @objc  convenience init(hexString: String, transparency: CGFloat = 1) {
        var string = ""
        if hexString.lowercased().hasPrefix("0x") {
            string =  hexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }
        
        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        
        let hexValue = Int(string, radix: 16) ?? 0
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
    
    /// SwifterSwift: Create Color from a complementary of a Color (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace: ((_ color: UIColor) -> UIColor?) = { color -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1]]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }
        
        let color = convertColorToRGBSpace(color)
        guard let componentColors = color?.cgColor.components else { return nil}
        
        let red: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let green: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let blue: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func hexString(includeAlpha: Bool = false) -> String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        if (includeAlpha) {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
    
    
    convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue    = CGFloat( hex3 & 0x00F      ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red     = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green   = CGFloat((hex4 & 0x0F00) >>  8) / divisor
        let blue    = CGFloat((hex4 & 0x00F0) >>  4) / divisor
        let alpha   = CGFloat( hex4 & 0x000F       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
        let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    convenience init?(rgba: String) {
        
        guard rgba.hasPrefix("#") else {
            return nil
        }
        let hexString: String =  rgba.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var hexValue:  UInt32 = 0
        
        guard Scanner.init(string: hexString).scanHexInt32(&hexValue) else {
            return nil
        }
        
        switch (hexString.count) {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        case 8:
            self.init(hex8: hexValue)
        default:
            return nil
        }
        
    }
}

fileprivate func hexStringToColorValue(hexString:String)->(CGFloat,CGFloat,CGFloat){
    var colorStr = (hexString as NSString).replacingOccurrences(of: " ", with: "") as NSString
    
    guard colorStr.length >= 6 else {
        return (0.0,0.0,0.0)
    }
    
    if colorStr.hasPrefix("0X") {
        colorStr = colorStr.substring(from: 2) as NSString
    }
    if colorStr.hasPrefix("#"){
        colorStr = colorStr.substring(from: 1) as NSString
    }
    
    if colorStr.length != 6{
        return (0.0,0.0,0.0)
    }
    var range = NSRange.init(location: 0, length: 2)
    let redStr = colorStr.substring(with: range)
    
    range.location = 2
    let greenStr = colorStr.substring(with: range)
    
    range.location = 4
    let blueStr = colorStr.substring(with: range)
    
    return (hexStringToDouble(from: redStr),hexStringToDouble(from: greenStr),hexStringToDouble(from: blueStr))
}

public func hexStringToDouble(from:String) -> CGFloat {
    let str = from.uppercased()
    var sum = 0.0
    for i in str.utf8 {
        sum = sum * 16.0 + Double(i) - 48.0
        if i >= 65 {
            sum -= 7.0
        }
    }
    return CGFloat(sum)
}

public func UIColorFromRGB(rgbValue: Int) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

