//
//  UUDevicePing.swift
//  TestCamera
//
//  Created by Asun on 2020/10/16.
//

import Foundation


public protocol UUNetWorkPingDelegate: AnyObject {
    func didReceive(response: PingResponse)
}

class UUDeviceNetworkPing {
    
    var ping: SwiftyPing?
    
    var host: String = ""
    
    var config: PingConfiguration = PingConfiguration.init(interval: 2, with: 3)
    
    public weak var delegate: UUNetWorkPingDelegate?
    
    private init() { }
    
    /// 监听网络Ping
    /// - Parameters:
    ///   - host: 监听地址
    ///   - pingConfig: 配置监听定时时间 超时间隔
    ///   - delegate: 回调网速
    required init(host: String = "www.baidu.com", pingConfig: PingConfiguration = .init(interval: 2, with: 3), delegate: UUNetWorkPingDelegate) {
        config = pingConfig
        self.host = host
        ping = try? SwiftyPing.init(host: host, configuration: pingConfig, queue: .global())
        self.delegate = delegate
    }
    
    /// 开启Ping监测
    public func startListenNetworkPing() {
        do {
            ping = try? SwiftyPing.init(host: host, configuration: config, queue: .global())
            
            ping?.observer = { [weak self] resp in
                guard let `self` = self,
                      let del = self.delegate
                else {return}
                DispatchQueue.main.async {
                    del.didReceive(response: resp)
                }
            }
            try ping?.startPinging()
        } catch {
            print("网络监测开启失败")
        }
    }
    
    public func observableToNetWork(){
        ping?.observer = { [weak self] resp in
            guard let `self` = self,
                  let del = self.delegate
            else {return}
            DispatchQueue.main.async {
                del.didReceive(response: resp)
            }
        }
    }
    /// 关闭Ping监测并置为空
    public func stopListenNetworkPing() {
        ping?.haltPinging()
    }
}
