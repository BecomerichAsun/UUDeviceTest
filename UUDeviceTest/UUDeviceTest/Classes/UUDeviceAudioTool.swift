//
//  AudioTool.swift
//  Online-HD
//
//  Created by iOSDeveloper on 2020/8/13.
//  Copyright © 2020 Asun. All rights reserved.
//  播放音频 和录制

import Foundation
import AVFoundation

class AudioTool: NSObject , AVAudioPlayerDelegate {
    
    
    static let instance = AudioTool()
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
    var aacPath:String? //录音存储路径
    var isPause = false //是否中断播放 默认是false
    var avPlayer: AVPlayer?
    var avPlayerItem:AVPlayerItem?
    var avPlayerState =  false // 外界判断状态
    var isAvPlayerPause = false
    var maicphonePlayComplete : (() -> ())?
    var videoPlayComplete : (() -> ())?
    var speakerPlayComplete : (() -> ())?
    ///当前流媒体音量
    var volume : Float
    override init() {
        volume = AVAudioSession.sharedInstance().outputVolume
        super.init()
        //初始化录音器 在初始化录音器视为了解决开始卡顿的情况
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        try! session.setCategory(.playAndRecord, options: [.allowBluetooth,.defaultToSpeaker])
        
        //设置支持后台
        try! session.setActive(true)
        
        //初始化字典并添加设置参数
        recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 ,//录音器每秒采集的录音样本数
            ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForegroundNotification), name:UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func appWillEnterForegroundNotification(){
        if isPause {
            self.continueToPlay()
        }
    }
    
    @objc func appWillEnterBackgroundNotification(){
        
        self.pausePlayAudio()
    }
    
    ///开始录音
    func startRecording(page: String) {
        
        //获取Document目录
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask, true)[0]
        //组合录音文件路径
        aacPath = docDir + "/\(page)cateRecording.aac"
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!,
                                        settings: recorderSeetingsDic!)
        if recorder != nil {
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
        }
    }
    
    ///停止录音
    func stopRecording() {
        recorder?.stop()
        recorder = nil
    }
    
    /// 播放远程mp3 文件
    func avPlayerStartPlay(url: String){
        if url.isEmpty {
            return
        }
        
        avPlayerItem = AVPlayerItem(url: URL(string: url)!)
        avPlayer =  AVPlayer(playerItem: avPlayerItem!)
        
        avPlayer?.volume = 1
        ///无需释放,这是单列
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayerItem)
        if avPlayer == nil {
            print("播放文件有问题")
        }else{
            avPlayer?.play()
            isAvPlayerPause = false
            avPlayerState = true
        }
    }
    
    func avPlayerStopPlay() {
        
        if avPlayerState {
            avPlayer?.seek(to: CMTime.init(value: 0, timescale: 1))
            avPlayer = nil
        }
    }
    
    func avPlayerPause(){
        
        if !isAvPlayerPause {
            avPlayer?.pause()
            isAvPlayerPause = true
            avPlayerState = false
        }
    }
    
    func avPlayerContinuePlay() {
        if isAvPlayerPause {
            avPlayer?.play()
            isAvPlayerPause = false
            avPlayerState = true
        }
        
    }
    ///开始播放音频 -本地文件
    func playAudio(localUrl: String) {
        
        if self.player != nil {
            self.player = nil
        }
        if localUrl.isEmpty { return}
        ///处理异常
        guard let _ = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: localUrl)) else {
            
            return
        }
        //初始化录音器 在初始化录音器视为了解决开始卡顿的情况
        let session:AVAudioSession = AVAudioSession.sharedInstance()
      
        try! session.setCategory(.playAndRecord, options: [.allowBluetooth,.defaultToSpeaker])
        //设置支持后台
        try! session.setActive(true)
        player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: localUrl))
        player?.delegate = self
        player?.volume = 1
        if player == nil {
            print("播放失败")
        }else{
            player?.play()
            isPause = false
        }
    }
    
    
    ///结束播放音频
    func stopPlayAudio(){
        player?.stop()
        isPause = false
    }
    
    ///暂停播放
    func pausePlayAudio() {
        if player?.isPlaying ?? false {
            player?.pause()
            isPause = true
        }
    }
    
    func continueToPlay(){
        if !(player?.isPlaying ?? false)  {
            player?.play()
        }
    }
    
    
    @objc func  finishedPlaying() {
        if self.maicphonePlayComplete != nil {
            self.maicphonePlayComplete!()
        }
        
        if self.videoPlayComplete != nil {
            self.videoPlayComplete!()
        }
        
        if self.speakerPlayComplete != nil {
            self.speakerPlayComplete!()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            if self.maicphonePlayComplete != nil {
                self.maicphonePlayComplete!()
            }
            
            if self.videoPlayComplete != nil {
                self.videoPlayComplete!()
            }
            
            if self.speakerPlayComplete != nil {
                self.speakerPlayComplete!()
            }
        }
    }
    
}
