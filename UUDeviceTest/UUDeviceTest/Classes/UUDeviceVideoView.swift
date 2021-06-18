//
//  UUDeviceVideoView.swift
//  UUDeviceCheck_Example
//
//  Created by Asun on 2020/10/16.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
/// 摄像头捕获区域

class UUDeviceVideoView: UIView {
    /// 管理输入输出音视频流
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    
    private var captureInput: AVCaptureDeviceInput?
    
    @available(iOS 10.0, *)
    private lazy var captureImageOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    
    lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 调用摄像头开启
    /// - Parameter vc: 如果权限未开启 会提示开启 需传入当前控制器
    public func startRunningWithMode(vc: UIViewController) {
        self.createDeviceVideoInput()
            .createDevicePhotoOutput()
            .checkMedia(jumpVc: vc, checkSuccessClosure: {
                if let input = captureInput,self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
                if self.captureSession.canAddOutput(self.captureImageOutput) {
                    self.captureSession.addOutput(self.captureImageOutput)
                }
            })
            .createDevicePreviewLayer(videoOrientation: .landscapeRight)
            .settingDeviceSessionAttributes(present: .high)
            .swapFrontAndBackCameras()
            .addSubLayerToShow()
            .startCapturing()
    }
    
}

extension UUDeviceVideoView {
    
    /// 添加捕获区域到当前View
    /// - Returns: 返回当前对象
    private func addSubLayerToShow() -> UUDeviceVideoView{
        self.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = layer.bounds
        return self
    }
    
    /// 创建摄像头输入
    /// - Returns: 返回当前对象
    @discardableResult
    private func createDeviceVideoInput() -> UUDeviceVideoView {
        let dev = AVCaptureDevice.default(for: .video)
        try? dev?.lockForConfiguration()
        dev?.unlockForConfiguration()
        if let device = dev {
            self.captureInput = try? AVCaptureDeviceInput.init(device: device)
        }
        return self
    }
    
    /// 创建视频输出格式
    /// - Returns: 返回当前对象
    @available(iOS 10.0, *)
    @discardableResult
    private func createDevicePhotoOutput() -> UUDeviceVideoView {
        if #available(iOS 11.0, *) {
            captureImageOutput.photoSettingsForSceneMonitoring = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        } else {
            // Fallback on earlier versions
        }
        
        return self
    }
    
    /// 设置视频质量
    /// - Parameter present: 视频质量 AVCaptureSession.Preset
    /// - Returns: 返回当前对象
    @discardableResult
    private func settingDeviceSessionAttributes(present: AVCaptureSession.Preset?) -> UUDeviceVideoView {
        self.captureSession.sessionPreset = present ?? .high
        return self
    }
    
    /// 设置捕获区域 样式
    /// - Parameters:
    ///   - videoGravity: 填充 默认充满
    ///   - videoOrientation: 方向 默认竖屏
    ///   - backgroundColor: 背景色 默认黑色
    ///   - cornerRadius: 圆角 默认不切圆角
    ///   - maskToBounds: 裁剪 默认False
    /// - Returns: 返回当前对象
    @discardableResult
    private func createDevicePreviewLayer(videoGravity: AVLayerVideoGravity? = .resizeAspectFill,
                                          videoOrientation: AVCaptureVideoOrientation? = .landscapeRight,
                                          backgroundColor: UIColor? = .black,
                                          cornerRadius: CGFloat? = 0) -> UUDeviceVideoView {
        videoPreviewLayer.videoGravity = videoGravity ?? .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        videoPreviewLayer.backgroundColor = backgroundColor?.cgColor ?? UIColor.black.cgColor
        videoPreviewLayer.cornerRadius = cornerRadius ?? 0
        videoPreviewLayer.masksToBounds = cornerRadius ?? 0 > 0
        videoPreviewLayer.session = captureSession
        return self
    }
    
    /// 检测摄像头权限
    /// - Parameters:
    ///   - jumpVc: 当前VC
    ///   - checkSuccessClosure: 检测成功后续操作
    ///   - tipsStatuStr: 检测不成功 提示
    ///   - tipsOpenSettingStr: 检测不成功 按钮文字
    /// - Returns: 返回当前对象
    @discardableResult
    
    private func checkMedia(jumpVc: UIViewController
                            , checkSuccessClosure:()->() = {}
                            ,_ tipsStatuStr:String = "摄像头权限关闭,请在设置中启用"
                            ,_ tipsOpenSettingStr: String = "去设置") -> UUDeviceVideoView {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let check: Bool = authStatus != .restricted && authStatus != .denied
        if !check {
            let alertView = UIAlertController(title: nil, message: tipsStatuStr, preferredStyle: .alert)
            let settingAction = UIAlertAction(title: tipsOpenSettingStr, style: .default) { (action) in
                let url = URL(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
            alertView.addAction(settingAction)
            jumpVc.present(alertView, animated: true, completion: nil)
        } else{
            checkSuccessClosure()
        }
        return self
    }
    
    /// 将摄像头设置为前置
    @discardableResult
    private func swapFrontAndBackCameras() -> UUDeviceVideoView{
        let inputs = self.captureSession.inputs as? [AVCaptureDeviceInput] ?? []
        for input in inputs {
            let device = input.device
            if device.hasMediaType(.video) {
                let position = device.position
                var newCamera: AVCaptureDevice?
                var newInput: AVCaptureDeviceInput?
                
                //                if position == .front {
                //                    newCamera = self.cameraWithPosition(position: .back)
                //                } else {
                newCamera = self.cameraWithPosition(position: .front)
                //                }
                newInput = try? AVCaptureDeviceInput.init(device: newCamera!)
                
                self.captureSession.beginConfiguration()
                self.captureSession.removeInput(input)
                self.captureSession.addInput(newInput!)
                self.captureSession.commitConfiguration()
                break
            }
        }
        return self
    }
    
    
    /// 切换摄像头方向
    /// - Parameter position: 设定方向
    /// - Returns: 返回包含当前方向
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices(for: .video)
        var device: AVCaptureDevice?
        devices.forEach { (d) in
            if d.position == position {
                device = d
            }
        }
        return device!
    }
    
    /// 开始捕获
    func startCapturing() {
        self.captureSession.startRunning()
    }
    
    /// 停止捕获
    func stopCapturing() {
        self.captureSession.stopRunning()
    }
}
