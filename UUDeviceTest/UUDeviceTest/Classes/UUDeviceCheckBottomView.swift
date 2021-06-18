//
//  UUDeviceCheckBottomView.swift
//  Pods-UUDeviceCheckSDK_Example
//
//  Created by iOSDeveloper on 2020/10/29.
//

import UIKit

class UUDeviceCheckBottomView: UIView {
    
    var viewArr = [UIView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewArr.removeAll()
        uiConfig()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bottomViewProgressConfig(_ index: Int) {
        for view in self.viewArr {
            if view.tag <= index {
                view.backgroundColor = UIColor.color(hexString: "#13779C")
            }else{
                view.backgroundColor = UIColor.color(hexString: "#1D3A66")
            }
        }
    }
    
    func uiConfig() {
        
        self.backgroundColor = .clear
        let viewW = (UIScreen.main.bounds.width - 6)/4
        for i  in 0..<4 {
            let view = UIView()
            view.backgroundColor = UIColor.color(hexString: "#1D3A66")
            self.addSubview(view)
            view.snp.makeConstraints {
                $0.left.equalToSuperview().offset(CGFloat(i) * (viewW + 2))
                $0.height.equalToSuperview().offset(1~)
                $0.bottom.equalToSuperview()
                $0.width.equalTo(viewW)
            }
            view.tag = i
            self.viewArr.append(view)
        }
    }
}
