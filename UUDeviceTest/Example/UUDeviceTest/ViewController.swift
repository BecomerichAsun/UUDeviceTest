//
//  ViewController.swift
//  UUDeviceModule
//
//  Created by becomerichios@163.com on 11/09/2020.
//  Copyright (c) 2020 becomerichios@163.com. All rights reserved.
//

import UIKit
import UUDeviceTest

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIApplication.shared.statusBarFrame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UUDeviceCheckController()
        vc.modalPresentationStyle = .fullScreen
        /// 呼叫班主任回调
        vc.callTheHeadTeacherForHelp {
            print("呼叫班主任")
        }
        /// 设备检测结果
        vc.deviceCheckCompleteWithResultModel { (mode) in
            
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}

