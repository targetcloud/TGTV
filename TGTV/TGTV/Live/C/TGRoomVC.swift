//
//  TGRoomVC.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/11.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit
import Kingfisher
import IJKMediaFramework

private let kMoreInfoViewH : CGFloat = 60
private let kSocialShareViewH : CGFloat = 158
private let kChatViewH : CGFloat = 44
private let kChatContentViewH : CGFloat = 158
private let kGiftViewH : CGFloat = 335

class TGRoomVC: TGBaseVC {

    var anchor : TGAnchorM?
    
    @IBOutlet weak var contributeLbl: UILabel!
    @IBOutlet weak var bgImageV: UIImageView!
    @IBOutlet weak var iconImageV: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var roomNumLbl: UILabel!
    @IBOutlet weak var onlineLbl: UILabel!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    
    fileprivate lazy var chatV : TGChatV = TGChatV.loadFromNib()
    fileprivate lazy var giftV : TGGiftListV = TGGiftListV.loadFromNib()
    fileprivate lazy var moreInfoV: TGMoreInfoV = TGMoreInfoV.loadFromNib()
    fileprivate lazy var shareV: TGShareV = TGShareV.loadFromNib()
    fileprivate lazy var chatContentV: TGChatContentV = TGChatContentV.loadFromNib()
    fileprivate lazy var giftContainerV : TGGiftContainerV = {
        let style : TGGiftStyle = TGGiftStyle()
        style.ChannelCount = 2
        style.BGColor = UIColor.clear
        style.isNeedFadeOutEffect = true
        style.inDirection = .right
        style.outDirection = .none
        return TGGiftContainerV(frame : CGRect(x: 0, y: 100, width: 250, height: 0),style:style)
    }()
    fileprivate lazy var clientSocket : TGSocketClient = TGSocketClient(address: "192.168.1.102", prot: 9898)//
    fileprivate var ijkPlayer: IJKFFMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if clientSocket.connectServer(5){
//            print("连接到服务器成功")
            clientSocket.sendJoinMsg()
            clientSocket.delegate = self
        }
        
        loadAnchorLiveAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clientSocket.sendLeaveMsg()
        ijkPlayer?.shutdown()
    }

    @objc fileprivate func keyboardWillChangeFrame(_ note: Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatViewH
//        print("监听键盘弹出\(endFrame)\(inputViewY)")
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatViewH) ? kScreenH : inputViewY
            self.chatV.frame.origin.y = endY
        
            let chatContentEndY = inputViewY == (kScreenH - kChatViewH) ? (kScreenH - kChatContentViewH - kChatViewH) : endY - kChatContentViewH
            self.chatContentV.frame.origin.y = chatContentEndY
        })
    }

}


extension TGRoomVC{
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
        view.addSubview(giftContainerV)
        setupInfo()
    }
    
    private func setupInfo(){
//        print(" ---\(anchor?.pic74) ---\(anchor?.pic51)")
        bgImageV.setImage(anchor?.pic74)
        iconImageV.setImage(anchor?.pic51)
        nickNameLbl.text = anchor?.name
        roomNumLbl.text = "房间号: \(anchor?.roomid ?? 0)"
        onlineLbl.text = "\(anchor?.focus ?? 0)"
        giftV.Anchor = anchor?.name
        contributeLbl.text = "\(arc4random_uniform(123456789))"
    }
    
    private func setupBottomView () {
        chatV.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatViewH)
        chatV.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        chatV.delegate = self
        view.addSubview(chatV)
        
        chatContentV.frame = CGRect(x: 0, y: view.bounds.height - kChatViewH - kChatContentViewH, width: view.bounds.width, height: kChatContentViewH)
        chatContentV.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(chatContentV)
        
        giftV.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftViewH)
        giftV.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        giftV.delegate = self
        view.addSubview(giftV)
        
        moreInfoV.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kMoreInfoViewH)
        moreInfoV.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(moreInfoV)
        
        shareV.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kSocialShareViewH)
        shareV.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        view.addSubview(shareV)
    }
    
    private func setupBlurView() {
        let blur  = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageV.bounds
        bgImageV.addSubview(blurView)
    }
}

extension TGRoomVC{
    fileprivate func loadAnchorLiveAddress() {
        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056",
                                           "signature" : "f69f4d7d2feb3840f9294179cbcb913f",
                                           "roomId" : anchor!.roomid,
                                           "userId" : anchor!.uid]
        NetworkTools.share.requestData(.get, URLString: URLString, parameters: parameters) { (result) in
//            print(" ---\(result)" )
            guard let resultDict = result as? [String : Any],let infoDict = resultDict["message"] as? [String : Any],let rURL = infoDict["rUrl"] as? String else {
                return
            }
            NetworkTools.share.requestData(.get, URLString: rURL, parameters: nil, finishedCallback: { (result) in
                print(" ---\(result)")
                guard let resultDict = result as? [String : Any],let liveURLString =  resultDict["url"] as? String else{
                    return
                }
                self.displayLiveView(liveURLString)
            })
        }
    }
    
    private func displayLiveView(_ liveURLString: String?) {
        guard let liveURLString = liveURLString else {
            return
        }
        let options = IJKFFOptions.byDefault()
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)// 1硬解码 0软解码
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: liveURLString, with: options)
        if anchor?.push == 1 {
            ijkPlayer?.view.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: bgImageV.bounds.width, height: bgImageV.bounds.width * 3 / 4))
        }else {
            ijkPlayer?.view.frame = bgImageV.bounds
        }
        bgImageV.addSubview((ijkPlayer?.view)!)
        ijkPlayer?.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        ijkPlayer?.prepareToPlay()
    }
}

extension TGRoomVC:TGEmitterable{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25) {
            self.chatV.inputTextField.resignFirstResponder()
            self.stackBottomConstraint.constant = 0
            self.giftV.frame.origin.y = kScreenH
            self.moreInfoV.frame.origin.y = kScreenH
            self.shareV.frame.origin.y = kScreenH
        }
    }
    
    @IBAction func exitBtnClick() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            chatV.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
            stackBottomConstraint.constant = -44
            UIView.animate(withDuration: 0.25, animations: {
                self.shareV.frame.origin.y = kScreenH - kSocialShareViewH
            })
            shareV.showShareView()
        case 2:
            print("点击了礼物")
            stackBottomConstraint.constant = -44
            UIView.animate(withDuration: 0.25, animations: {
                self.giftV.frame.origin.y = kScreenH - kGiftViewH
            })
        case 3:
            print("点击了更多")
            stackBottomConstraint.constant = -44
            UIView.animate(withDuration: 0.25, animations: {
                self.moreInfoV.frame.origin.y = kScreenH - kMoreInfoViewH
            })
            moreInfoV.showMoreInfoView()
        case 4:
            print("点击了粒子")
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("请检查")
        }
    }
    
    @IBAction func focusBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            anchor?.inserIntoDB()
        } else {
            anchor?.deleteFromDB()
        }
    }
}

extension TGRoomVC:TGChatViewDelegate{
    func chatView(chatView: TGChatV, message: String) {
//        print(message)
        clientSocket.sendTextMsg(message)
    }
}

extension TGRoomVC:TGGiftListViewDelegate{
    func giftListView(giftListView: TGGiftListV, giftModel: TGGiftM) {
//        print(giftModel.subject)
        clientSocket.sendGiftMsg(giftModel.subject, giftModel.img2,  1)
    }
}

extension TGRoomVC{
    
}

extension TGRoomVC : TGSocketClientDelegate {
    func socket(_ socket : TGSocketClient,joinRoom userInfo :UserInfo){
        let attr = AttributedStringTool.generateJoinOrLeaveRoom(userInfo.name, true)
        chatContentV.insertMessage(attr)
    }
    
    func socket(_ socket : TGSocketClient,leaveRoom userInfo :UserInfo){
        let attr = AttributedStringTool.generateJoinOrLeaveRoom(userInfo.name, false)
        chatContentV.insertMessage(attr)
    }
    
    func socket(_ socket : TGSocketClient,sendChatMsg chatMsg :ChatMessage){
        let attr = AttributedStringTool.generateTextMessage(chatMsg.user.name, chatMsg.text)
        chatContentV.insertMessage(attr)
    }
    
    func socket(_ socket : TGSocketClient,sendGift giftMsg :GiftMessage){
        let attr = AttributedStringTool.generateGiftMessge(giftMsg.user.name, giftMsg.giftname, giftMsg.giftUrl)
        chatContentV.insertMessage(attr)
        let giftMsgModel = TGGiftAnimationM(senderName: giftMsg.user.name, senderURL: "icon\(arc4random_uniform(4))", giftName: giftMsg.giftname, giftURL: giftMsg.giftUrl)
        giftContainerV.showGiftModel(giftMsgModel)
    }
}
