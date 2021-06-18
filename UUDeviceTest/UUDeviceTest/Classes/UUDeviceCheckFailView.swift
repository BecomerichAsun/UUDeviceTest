//
//  UUDeviceCheckFailView.swift
//  UUDeciceCheckSDK
//
//  Created by iOSDeveloper on 2020/10/22.
//  Copyright © 2020 xiananwu. All rights reserved.
//

import UIKit

struct UUDeviceCheckItmeModel {
    var title = ""
    var icon = ""
    
    mutating func changeTitlte(_ str: String) {
        title = str
    }
}

class UUDeviceCheckFailView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var subLable = UILabel().uu_creatLable(color: "#FFFFFF", font: 14, title: "不过没关系,你可以点击下方按钮,呼唤班主任解决帮忙解决问题哦~!")
    let mianTitleLable = UILabel().uu_creatLable(color: "#FFFFFF", font: 16, title: "很遗憾,有点小问题，检测竟然没有全部通过~")
    lazy var backGroundImageView = UIImageView()
    lazy var contentImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestImage_testBackground"))
    lazy var logImageView = UIImageView.init(image: uu_image_Bundle(forResource: "aiTestResult_failImage"))
    lazy var clallTeacherBtn = UIButton()
    lazy var leftButton = UUDeviceCheckLeftButton.init(frame: .zero)
    lazy var rightButton = UUDeviceCheckRightButton.init(frame: .zero)
    var buttonAction: ((UUDeviceButtonType)->())?
    var callTeacherAction :(()->())?
    var dataArr = [UUDeviceCheckItmeModel]()
    var colloectionView :UICollectionView?
    lazy var crownAnimationView = UUSvgaAnimationCenter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func analysisAccordingToThetestResults(model: UUDeviceCheckResultModel) {
        
        self.dataArr.removeAll()
        if !model.netIsSuccess {
            var model = UUDeviceCheckItmeModel()
            model.title = "网络"
            model.icon = "btn_net"
            self.dataArr.append(model)
        }
        
        if !model.speakerIsSuccess {
            var model = UUDeviceCheckItmeModel()
            model.title = "扬声器"
            model.icon = "class_state_btn_vol"
            self.dataArr.append(model)
        }
        
        if !model.videoIsSuccess {
            var model = UUDeviceCheckItmeModel()
            model.title = "摄像头"
            model.icon = "class_state_btn_camera"
            self.dataArr.append(model)
        }
        
        if !model.maicphoneIsSuccess {
            var model = UUDeviceCheckItmeModel()
            model.title = "麦克风"
            model.icon = "class_state_btn_microphone"
            self.dataArr.append(model)
        }
        if self.colloectionView != nil {
            self.colloectionView?.removeFromSuperview()
        }
        let colloectionViewH:CGFloat = self.dataArr.count > 2 ? screenScale(74): screenScale(37)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: screenScale(400/2 - 1) , height: (37))
        colloectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        colloectionView?.isScrollEnabled = false
        colloectionView?.dataSource = self
        colloectionView?.delegate  = self
        colloectionView?.backgroundColor = UIColor(hex3: 0x000000, alpha: 0.15)
        colloectionView?.layer.cornerRadius = 7;
        colloectionView?.layer.masksToBounds = true;
        colloectionView?.register(UUDeviceCheckErrorCollectionCell.self, forCellWithReuseIdentifier: "cell")
        contentImageView.addSubview(self.colloectionView!)
        self.colloectionView?.snp.makeConstraints {
            $0.top.equalTo(subLable.snp.bottom).offset(15)
            $0.left.equalTo(self.subLable)
            $0.width.equalTo(screenScale(400))
            $0.height.equalTo((colloectionViewH))
        }
        self.leftButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-93~)
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                $0.bottom.equalToSuperview().offset(-40)
            } else {
                if self.dataArr.count > 2 {
                    $0.top.equalTo(colloectionView!.snp.bottom).offset(10)
                } else {
                    $0.bottom.equalToSuperview().offset(-40)
                }
            }
            
            $0.size.equalTo(CGSize(width: 153~, height: 37~))
        }
        self.rightButton.snp.makeConstraints {
            $0.bottom.size.centerY.equalTo(leftButton)
            $0.centerX.equalToSuperview().offset(93~)
        }
        
        self.clallTeacherBtn.snp.makeConstraints {
            $0.centerY.equalTo(rightButton)
            $0.right.equalTo(contentImageView).offset(-15~)
        }
        
        crownAnimationView.svgaPlayer.snp.makeConstraints {
            $0.top.equalTo(mianTitleLable)
            $0.centerX.equalTo(clallTeacherBtn)
            $0.size.equalTo(CGSize(width: screenScale(20), height: screenScale(10)))
        }
        self.colloectionView?.reloadData()
    }
    
    func startPlayVioce() {
        AudioTool.instance.playAudio(localUrl:uu_getBundle(forResource: "class_ai_result_fail.mp3")!)
    }
    
    @objc func leftButtonAction(){
        
        if buttonAction != nil {
            self.buttonAction!(.left)
        }
    }
    
    @objc func callTeacherBtnAction(){
        
        if self.callTeacherAction != nil{
            self.callTeacherAction!()
        }
    }
    
    
    @objc func rightButtonAction(){
        self.buttonAction!(.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UUDeviceCheckErrorCollectionCell
        cell.setErrorItemModel(model: self.dataArr[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UUDeviceFailDetailView.showDetailView(self.dataArr, defaultIndex: indexPath.row)
    }
    
    func uiConfig() {
        
        self.isUserInteractionEnabled = true
        backGroundImageView.isUserInteractionEnabled = true
        contentImageView.isUserInteractionEnabled = true
        self.addSubview(backGroundImageView)
        backGroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backGroundImageView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: screenScale(519~), height: 268~))
            $0.right.equalToSuperview().offset(screenScale(-37~))
            $0.centerY.equalToSuperview()
        }
        
        contentImageView.addSubview(mianTitleLable)
        mianTitleLable.snp.makeConstraints {
            $0.left.equalToSuperview().offset((75))
            $0.top.equalToSuperview().offset((43))
        }
        
        subLable.numberOfLines = 2
        contentImageView.addSubview(subLable)
        subLable.snp.makeConstraints {
            $0.top.equalTo(mianTitleLable.snp.bottom).offset((6))
            $0.left.equalTo(mianTitleLable)
            $0.right.equalToSuperview().offset((-78))
        }
        
        contentImageView.addSubview(leftButton)
        contentImageView.addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        
        leftButton.setTitle("重新检测", for: .normal)
        rightButton.setTitle("退出检测", for: .normal)
        
        clallTeacherBtn.setBackgroundImage(uu_image_Bundle(forResource: "clallTeacherBtn"), for: .normal)
        backGroundImageView.addSubview(clallTeacherBtn)
        
        
        clallTeacherBtn.addTarget(self, action: #selector(callTeacherBtnAction), for: .touchUpInside)
        backGroundImageView.addSubview(crownAnimationView.svgaPlayer)
        crownAnimationView.setSvgaAnimationWithSvgaName(svgaName: "dcl_ai_device_check_arrowr")
        
        backGroundImageView.addSubview(logImageView)
        logImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentImageView).offset(40)
            $0.right.equalTo(contentImageView.snp.left).offset(screenScale(40))
            $0.size.equalTo(CGSize(width: isDevicePlus == false ? screenScale(273~) : screenScale(273~)*0.8, height: isDevicePlus == false ? 283~ : 0.8*283~))
        }
    }
}
