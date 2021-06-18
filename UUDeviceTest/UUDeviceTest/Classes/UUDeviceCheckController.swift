//
//  UUDeviceCheckController.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/20.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

public enum networkStatus {
    case normal
    case noNetwork
    case suceessNetwork
}

@objcMembers open class UUDeviceCheckController: UIViewController, UUNetWorkPingDelegate {
    
    var networkStatus: networkStatus = .normal
    var netPingCheckManager :UUDeviceNetworkPing!
    var listener: UUNetworkReachabilityManager = UUNetworkReachabilityManager(host: "www.baidu.com")!
    var resultClosur: ((UUDeviceCheckResultModel)->())?
    lazy var manager = UUDeviceAuthorManager()
    lazy var bottomView = UUDeviceCheckBottomView.init(frame: .zero)
    lazy var checkResultModel = UUDeviceCheckResultModel()
    
    lazy var record = UUDeviceRecord()
  
    lazy var backgroudImageView = UIImageView.init(image: uu_image_Bundle(forResource: "UUCheckBackground"))
    
    lazy var checkInsertView = UUDeviceinsertErrorView()
    lazy var topListView = UUDeviceCheckTopView.init(frame: .zero)
    lazy var speakerView = UUDeviceCheckSpeakerView.init(frame: .zero)
    lazy var videoCheckView = UUDeviceCheckVideoView.init(frame: .zero)
    lazy var successCheckView = UUDeviceCheckSuccessView.init(frame: .zero)
    lazy var failCheckView = UUDeviceCheckFailView.init(frame: .zero)
    lazy var maicphoneCheckView = UUDeviceCheckMaicphoneView.init(frame: .zero)
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            SwiftyFitsize.reference(width: 812, iPadFitMultiple: 2.17)
        }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceAuthor().netCheckHandle().listenNetWork()
    }
    
    @discardableResult
    private func listenNetWork() -> UUDeviceCheckController {
        self.listener.listener = { [weak self] status in
            guard let `self` = self else { return }
            switch status {
            case .notReachable:
                self.netPingCheckManager.stopListenNetworkPing()
                self.topListView.netCheckResult(title: "网络: 未连接", isSuccess: false)
                self.networkStatus = .noNetwork
            case .reachable(.ethernetOrWiFi),.reachable(.wwan):
                if self.networkStatus == .normal || self.networkStatus == .noNetwork {
                    self.netPingCheckManager.startListenNetworkPing()
                    self.networkStatus = .suceessNetwork
                }
            default: break
            }
        }
        listener.startListening()
        return self
    }
    

    @discardableResult
    func handleActionEventBussiness()-> UUDeviceCheckController {
        ///扬声器检测结果
        speakerView.buttonActionClosure = { [weak self] type in
            guard let `self` = self else {return}
            AudioTool.instance.stopPlayAudio()
            let isSuccess = type == .left ? false : true
            self.topListView.speakerCheckResult(isSuccess: isSuccess)
            self.checkResultModel.speakerIsSuccess = isSuccess
            DispatchQueue.main.async {
                self.videoCheckView.videoView.isHidden = false
                self.speakerView.removeFromSuperview()
                self.backgroudImageView.addSubview(self.videoCheckView)
                self.videoCheckView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                self.videoCheckView.videoView.startRunningWithMode(vc: self)
                self.videoCheckView.startAnimationAndVioce(isOk: isSuccess)
                self.topListView.videoTexting()
                self.bottomView.bottomViewProgressConfig(2)
            }
        }
        
        ///视频检测结果
        videoCheckView.buttonActionClosure = { [weak self] type in
            guard let `self` = self else {return}
            let isSuccess = type == .left ? false : true
            self.topListView.videoCheckResult(isSuccess: isSuccess)
            self.checkResultModel.videoIsSuccess = isSuccess
            if isSuccess {
                DispatchQueue.main.async {
                    self.videoCheckView.removeFromSuperview()
                    self.backgroudImageView.addSubview(self.maicphoneCheckView)
                    self.maicphoneCheckView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                    self.maicphoneCheckView.startAnimationAndVioce(isOk: isSuccess)
                    self.maicphoneCheckHandle()
                    self.topListView.maicphoneTexting()
                    self.bottomView.bottomViewProgressConfig(3)
                }
            } else {
                DispatchQueue.main.async {
                    self.videoCheckView.removeFromSuperview()
                    self.checkInsertView.startAnimationAndVioce()
                    self.backgroudImageView.addSubview(self.checkInsertView)
                    self.checkInsertView.snp.makeConstraints{
                        $0.edges.equalToSuperview()
                    }
                }
            }
        }
        
        self.checkInsertView.buttonActionClosure = { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.checkInsertView.removeFromSuperview()
                self.backgroudImageView.addSubview(self.maicphoneCheckView)
                self.maicphoneCheckView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                self.maicphoneCheckView.startAnimationAndVioce(isOk: self.checkResultModel.videoIsSuccess)
                self.maicphoneCheckHandle()
                self.topListView.maicphoneTexting()
                self.bottomView.bottomViewProgressConfig(3)
            }
        }
        
        ///麦克风检测结果与逻辑
        maicphoneCheckView.buttonActionClosure = { [weak self] in
            guard let `self` = self else {return}
            let isSuccess = $0 == .left ? false : true
            DispatchQueue.main.async {
                self.topListView.maicphoneCheckResult(isSuccess: isSuccess)
                self.checkResultModel.maicphoneIsSuccess = isSuccess
                if self.resultClosur != nil{
                    self.resultClosur!(self.checkResultModel)
                }
                self.maicphoneCheckView.removeFromSuperview()
                if self.checkResultModel.maicphoneIsSuccess,
                   self.checkResultModel.netIsSuccess,
                   self.checkResultModel.speakerIsSuccess,
                   self.checkResultModel.videoIsSuccess{
                    
                    self.backgroudImageView.addSubview(self.successCheckView)
                    self.successCheckView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                    self.successCheckView.startPalyVioce()
                }else{
                    self.backgroudImageView.addSubview(self.failCheckView)
                    self.failCheckView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                    self.failCheckView.startPlayVioce()
                    self.failCheckView.analysisAccordingToThetestResults(model: self.checkResultModel)
                }
                self.topListView.removeFromSuperview()
                
            }
        }
        
        successCheckView.exitClosure = { [weak self] in
            guard let `self` = self else {return}
            self.exitDeviceCheck()
        }
        
        failCheckView.buttonAction = { [weak self] in
            guard let `self` = self else {return}
            AudioTool.instance.stopPlayAudio()
            switch $0 {
            ///重新检测
            case .left:
                DispatchQueue.main.async {
                    self.failCheckView.removeFromSuperview()
                    self.topListView.removeFromSuperview()
                    self.topListView = UUDeviceCheckTopView.init(frame: .zero)
                    self.uu_UIConfig()
                    self.checkResultModel = UUDeviceCheckResultModel()
                    self.speakerView.aiPlayVioceButton.setAiPlayVioceButtonState(statue: .startPlay)
                }
                
                break
            case .right:
                self.exitDeviceCheck()
                break
            }
        }
        return self
    }
    

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        netPingCheckManager.stopListenNetworkPing()
        netPingCheckManager.delegate = nil
        listener.stopListening()
        record.stopRecord()
        AudioTool.instance.stopPlayAudio()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uu_UIConfig()
            .handleActionEventBussiness()
    }
    
    
    @discardableResult
    func checkDeviceAuthor() -> UUDeviceCheckController {
        manager.showUserGotoSetOpenAuthorClosure = {[weak self] type in
            guard let `self` = self else {return}
            switch type {
            case .audio:
                self.showAuthorView(type: .audio)
                break
            case .video:
                self.showAuthorView(type: .video)
                break
            }
            
        }
        manager.checkUserAuthorIsOpen()
        return self
    }
    
    
    ///网络检测
    @discardableResult
    func netCheckHandle() -> UUDeviceCheckController {
        netPingCheckManager = UUDeviceNetworkPing.init(host: "www.baidu.com", pingConfig: .init(interval: 2, with: 5), delegate: self)
        return self
    }
    
    ///麦克风检测
    @discardableResult
    func maicphoneCheckHandle() -> UUDeviceCheckController {
        record.startRecord()
        record.recorderVolumeClosure = { [weak self] volume  in
            guard let `self` = self else {return}
            let isStartAnimation = volume > 0.4 ? true: false
            self.maicphoneCheckView.maiphoneAnimationConfig(isStartAnimation: isStartAnimation)
        }
        return self
    }
    
    ///UUNetWorkPingDelegate
    public func didReceive(response: PingResponse) {
        var isNetSucess: Bool
        var title = ""
        
        if response.error == PingError.requestTimeout{
            isNetSucess = false
            title = "网络: 超时"
        }else if  Int((response.duration) * 1000) > 250 {
            isNetSucess = false
            title = "网络: \(Int((response.duration) * 1000))ms"
        }else{
            isNetSucess = true
            title = "网络: \(Int((response.duration) * 1000))ms"
        }
        self.checkResultModel.netIsSuccess = isNetSucess
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            self.topListView.netCheckResult(title: title, isSuccess: isNetSucess)
        }
    }
    
    func showAuthorView(type: UUDeviceCheckType){
        var title : String?
        switch type {
        case .video:
            title = "相机权限未开启"
            break
        case .audio:
            title = "麦克风权限未开启"
            break
        }
        let vc = UUAlert(title: title, message: "无法进行设备检测", preferredStyle: .alert)
        let canceAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            if self.navigationController == nil{
                self.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        let setAction = UIAlertAction(title: "去设置", style: .default) { (_) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        vc.addAction(canceAction)
        vc.addAction(setAction)
        self.present(vc, animated: true, completion: nil)
    }
    
    ///呼叫班主任回调
    open func callTheHeadTeacherForHelp(closure: (()->())?) {
        if closure != nil {
            self.failCheckView.callTeacherAction = closure
        }
    }
    
    ///结果回调
    open func deviceCheckCompleteWithResultModel(result: @escaping (UUDeviceCheckResultModel)->()){
        self.resultClosur = result
    }
    
    open override var prefersStatusBarHidden: Bool{
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscape
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    open override var shouldAutorotate: Bool{
        return false
    }
}

extension UUDeviceCheckController{
    
    func exitDeviceCheck() {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @discardableResult
    func uu_UIConfig() -> UUDeviceCheckController {
        backgroudImageView.isUserInteractionEnabled = true
        self.view.addSubview(backgroudImageView)
        backgroudImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroudImageView.addSubview(topListView)
        topListView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(32~)
        }
        
        backgroudImageView.addSubview(speakerView)
        speakerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroudImageView.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        topListView.speakerTexting()
        bottomView.bottomViewProgressConfig(1)
        return self
    }
}

class UUAlert : UIAlertController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
