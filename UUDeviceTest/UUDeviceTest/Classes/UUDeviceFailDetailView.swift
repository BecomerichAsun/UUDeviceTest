//
//  UUDeviceFailDetailView.swift
//  UUDeviceModule
//
//  Created by Asun on 2020/12/2.
//

import UIKit

public enum UUDeviceDetailType: String {
    case network = "网络差"
    case camera = "摄像头问题"
    case mic = "麦克风问题"
    case soud = "扬声器问题"
}

public func uuDeviceIPhoneX() -> Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if  unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}

class UUDeviceFailDetailView: UIView {
    
    lazy var failDataArray:[UUDeviceCheckItmeModel] = []
    
    let topView: UIView = UIView()
    
    lazy var defaultIndex: Int = 0
    
    let closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(uu_image_Bundle(forResource: "btn_close"), for: .normal)
        return btn
    }()
    
    var linesArray: [UIView] = []
    var btnsArray: [UIButton] = []
    
    var statusType: UUDeviceDetailType!
    
    let descView: UUDeviceFailDetailDescView = UUDeviceFailDetailDescView()
    
    init(dataArray: [UUDeviceCheckItmeModel], defaultIndex: Int) {
        super.init(frame: .zero)
        self.failDataArray = dataArray.map({ (model) in
            var newModel = UUDeviceCheckItmeModel()
            if model.title.elementsEqual("网络") {
                newModel.title = "网络差"
            }else {
                newModel.title = model.title + "问题"
            }
            return newModel
        })
        self.defaultIndex = defaultIndex
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showDetailView(_ dataArray: [UUDeviceCheckItmeModel], defaultIndex: Int) {
        let detailView = UUDeviceFailDetailView(dataArray: dataArray, defaultIndex: defaultIndex)
        detailView.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(detailView)
        
        UIView.animate(withDuration: 0.3, animations: {
            detailView.alpha = 0.75
        }, completion: nil)
        let percent = 0.95
        detailView.transform = CGAffineTransform(scaleX: CGFloat(percent), y: CGFloat(percent))
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: UIView.AnimationOptions.curveEaseOut, animations: { detailView.transform = CGAffineTransform.identity }, completion: nil)
    }
}



extension UUDeviceFailDetailView {
    
    private func configUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(topView)
        
        topView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50~)
        }
        
        for (index,item) in failDataArray.enumerated() {
            createBtn(title: item.title, tag: index)
        }
        
        addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30~)
            $0.size.equalTo(CGSize(width: 37~, height: 37~))
        }
        
        addSubview(descView)
        
        descView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(15~)
            $0.leading.equalTo(80~)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(closeBtn.snp.top)
        }
        closeBtn.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
    }
    
    func createBtn(title: String, tag: Int) {
        let btn = UIButton()
        let lineView = UIView()
        lineView.isHidden = true
        lineView.backgroundColor = .red
        lineView.layer.cornerRadius = 2
        lineView.clipsToBounds = true
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.tag = tag
        topView.addSubview(lineView)
        topView.addSubview(btn)
        
        if tag == 0 {
            btn.snp.makeConstraints{
                $0.top.equalTo(topView)
                $0.leading.equalTo(80~)
                $0.bottom.equalTo(topView.snp.bottom).offset(-2~)
                $0.width.equalTo(100~)
            }
            lineView.snp.makeConstraints{
                $0.bottom.equalTo(topView)
                $0.height.equalTo(2~)
                $0.width.equalTo(50~)
                $0.centerX.equalTo(btn)
            }
        }else if tag == 1 {
            btn.snp.makeConstraints{
                $0.leading.equalTo(180~)
                $0.top.equalTo(topView)
                $0.bottom.equalTo(topView.snp.bottom).offset(-2~)
                $0.width.equalTo(100~)
            }
            lineView.snp.makeConstraints{
                $0.bottom.equalTo(topView)
                $0.height.equalTo(2~)
                $0.width.equalTo(50~)
                $0.centerX.equalTo(btn)
            }
        } else if tag == 2 {
            btn.snp.makeConstraints{
                $0.leading.equalTo(280~)
                $0.top.equalTo(topView)
                $0.bottom.equalTo(topView.snp.bottom).offset(-2~)
                $0.width.equalTo(100~)
            }
            lineView.snp.makeConstraints{
                $0.bottom.equalTo(topView)
                $0.height.equalTo(2~)
                $0.width.equalTo(50~)
                $0.centerX.equalTo(btn)
            }
        } else {
            btn.snp.makeConstraints{
                $0.leading.equalTo(380~)
                $0.top.equalTo(topView)
                $0.bottom.equalTo(topView.snp.bottom).offset(-2~)
                $0.width.equalTo(100~)
            }
            lineView.snp.makeConstraints{
                $0.bottom.equalTo(topView)
                $0.height.equalTo(2~)
                $0.width.equalTo(50~)
                $0.centerX.equalTo(btn)
            }
        }
        btnsArray.append(btn)
        linesArray.append(lineView)
        btn.addTarget(self, action: #selector(btnDetailClick), for: .touchUpInside)
        /// 默认选中
        if btn.tag == defaultIndex {
            btn.sendActions(for: .touchUpInside)
        }
    }
    
    @objc func btnDetailClick(target: UIButton) {
        for (index) in 0..<btnsArray.count {
            if index == target.tag {
                target.isSelected = true
                linesArray[index].isHidden = !target.isSelected
                bringType(index: index)
            }
            if index != target.tag {
                btnsArray[index].isSelected = false
                linesArray[index].isHidden = true
            }
        }
    }
    
    func bringType(index: Int) {
        self.statusType = UUDeviceDetailType(rawValue: self.failDataArray[index].title) ?? .camera
        if let type = self.statusType {
            self.descView.setStatusType(showType: type)
        }
        
        
    }
    
    @objc func closeClick() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { (finish) in
            self.removeFromSuperview()
        })
    }
}


class UUDeviceFailDetailDescView: UIView {
    
    let titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textColor = .white
        lab.text = "123131321231"
        return lab
    }()
    
    let oneLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textColor = .white
        lab.text = "1231313131231321"
        return lab
    }()
    
    let twoLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.text = "1231313131231321"
        lab.textColor = .white
        lab.numberOfLines = 2
        return lab
    }()
    
    let titleTwoLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.textColor = .white
        lab.text = "123131321231"
        return lab
    }()
    
    let networkOneLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textColor = .white
        lab.text = "1231313131231321"
        return lab
    }()
    
    let networkTwoLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.text = "1231313131231321"
        lab.textColor = .white
        return lab
    }()
    
    let supportLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.text = "1231313131231321"
        lab.textColor = .white
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(titleLabel)
        self.addSubview(oneLabel)
        self.addSubview(twoLabel)
        
        self.addSubview(supportLabel)
        
        self.addSubview(titleTwoLabel)
        self.addSubview(networkOneLabel)
        self.addSubview(networkTwoLabel)
        
        titleLabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
        }
        
        oneLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5~)
            $0.leading.equalTo(titleLabel)
        }
        
        twoLabel.snp.makeConstraints{
            $0.top.equalTo(oneLabel.snp.bottom).offset(2~)
            $0.leading.equalTo(oneLabel)
        }
        
        supportLabel.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.equalTo(twoLabel.snp.bottom).offset(5~)
        }
        
        titleTwoLabel.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.top.equalTo(twoLabel.snp.bottom).offset(15~)
        }
        
        networkOneLabel.snp.makeConstraints{
            $0.top.equalTo(titleTwoLabel.snp.bottom).offset(5~)
            $0.leading.equalTo(titleTwoLabel)
        }
        
        networkTwoLabel.snp.makeConstraints{
            $0.top.equalTo(networkOneLabel.snp.bottom).offset(2~)
            $0.leading.equalTo(networkOneLabel)
        }
    }
    
    func setStatusType(showType: UUDeviceDetailType) {
        titleTwoLabel.text = ""
        networkOneLabel.text = ""
        networkTwoLabel.text = ""
        titleLabel.text = ""
        supportLabel.text = ""
        switch showType {
        case .camera:
            oneLabel.text = "1. 确认相机权限给与，且没有被关闭"
            twoLabel.text = "2. 确认相机没有被其他应用占用"
            supportLabel.text = "没有解决？ 请联系班主任"
        case .mic:
            oneLabel.text = "1. 确认麦克风权限给与，且没有被关闭"
            twoLabel.text = "2. 确认麦克风没有被其他应用占用"
            supportLabel.text = "没有解决？ 请联系班主任"
        case .network:
            titleTwoLabel.text = "WIFI网络"
            networkOneLabel.text = "1.确认自己或家人没有进行下载，看视频等占用网络行为"
            networkTwoLabel.text = "2. 立即重启路由器并靠近路由器重试; 联系当地网络运营商，咨询网络异常解决方案"
            titleLabel.text = "蜂窝数据"
            oneLabel.text = "1. 选择相对宽阔的地方或靠近窗户的地方，尽量避免封闭的环境，如墙角"
            twoLabel.text = "2. 查看身边家人朋友网络状况，更换他人手机重新进入课堂。"
        case .soud:
            oneLabel.text = "1. 确认设备扬声器音量已调整到足够大"
            twoLabel.text = "2. 确认麦克风没有被其他应用占用"
            supportLabel.text = "没有解决？ 请联系班主任"
        }
    }
    
    
}
