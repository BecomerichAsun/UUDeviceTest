//
//  UUDeviceRecord.swift
//  TestCamera
//
//  Created by Asun on 2020/10/16.
//

import Foundation
import AVFoundation

@objcMembers open class UUDeviceRecord : NSObject{
    
    private var recorder:AVAudioRecorder? //录音器
    private var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    private var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
    private var aacPath:String? //录音存储路径
    public var recorderVolumeClosure :((Float)->())?
    
    override init() {
        super.init()
        createRecorder()
    }
    
    @discardableResult
    public func createRecorder() -> UUDeviceRecord {
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try! session.setCategory(.playAndRecord, options: [.allowBluetooth,.defaultToSpeaker])
        //设置支持后台
        try! session.setActive(true)
        //获取Document目录
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask, true)[0]
        //组合录音文件路径
        aacPath = docDir + "/play\(Date.init().timeIntervalSince1970).aac"
        //初始化字典并添加设置参数
        recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
            ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundNotification), name:UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        return self
    }
}

extension UUDeviceRecord {
    
    @objc func appWillEnterForegroundNotification() {
        self.relayRecord()
    }
    
    @objc func appWillEnterBackgroundNotification() {
        self.pauseRecord()
    }
    
    @discardableResult
    func startRecord() -> UUDeviceRecord {
        if recorder == nil {
            //初始化录音器
            recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,
                                            settings: recorderSeetingsDic!)
            if recorder != nil {
                //开启仪表计数功能
                recorder!.isMeteringEnabled = true
                //准备录音
                recorder!.prepareToRecord()
                //开始录音
                recorder!.record()
                //启动定时器，定时更新录音音量
                volumeTimer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                                   selector: #selector(self.levelTimer),
                                                   userInfo: nil, repeats: true)
            }
        }
        return self
    }
    
    func pauseRecord() {
        recorder?.pause()
    }
    
    func relayRecord() {
        recorder?.record()
    }
    
    func stopRecord() {
        recorder?.pause()
        recorder?.stop()
        //录音器释放
        recorder = nil
        
        //暂停定时器
        if volumeTimer != nil {
            volumeTimer.invalidate()
            volumeTimer = nil
        }
        
        recorderVolumeClosure = nil
    }
    
    //定时检测录音音量
    @objc func levelTimer() {
        if (recorder != nil) {
            recorder!.updateMeters() // 刷新音量数据

            var level: Float = 0
            let minDecibels: Float = -60
            let decibels = recorder?.averagePower(forChannel: 0) ?? 0
            
            if decibels<minDecibels {
                level = 0
            }
            else if decibels >= 0 {
                level = 1
            }
            else {
                let root = 5.0
                let minAmp = powf(10.0, 0.05*minDecibels)
                let inverseAmpRange = 1/(1-minAmp)
                let amp = powf(10.0, 0.05*decibels)
                let adjAmp = (amp - minAmp) * inverseAmpRange
                level = powf(adjAmp, Float(1.0 / root))
            }
            if let callBack = self.recorderVolumeClosure {
                callBack(level)
            }
        }
    }
}
