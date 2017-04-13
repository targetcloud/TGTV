//
//  TGChatV.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/12.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import UIKit

protocol TGChatViewDelegate : class {
    func chatView(chatView : TGChatV, message : String)
}

class TGChatV: UIView ,TGNibLoadable{
    weak var delegate : TGChatViewDelegate?
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    fileprivate lazy var emoticonBtn: UIButton = {
        let btn =  UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        btn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        btn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        btn.addTarget(self, action: #selector(emoticonBtnClick), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var emoticonV: TGEmoticonV = TGEmoticonV(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sendBtn.isEnabled = false
        setupUI()
    }
    
    @IBAction func textFieldDidEdit(_ sender: UITextField) {
        sendBtn.isEnabled = sender.text!.characters.count != 0
    }
    
    fileprivate func setupUI() {
        inputTextField.rightView = emoticonBtn
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true

        emoticonV.emoticonClickCallBack = { [weak self] emoticon in
            print(emoticon.emoticonName)
            if emoticon.emoticonName == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            guard let range = self?.inputTextField.selectedTextRange else {
                return
            }
            self?.inputTextField.replace(range, withText: emoticon.emoticonName)
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        guard let message = inputTextField.text else {
            return
        }
        inputTextField.text = ""
        sender.isEnabled = false
        delegate?.chatView(chatView: self, message: message)
    }
    
    @objc fileprivate func emoticonBtnClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        let range = inputTextField.selectedTextRange
        inputTextField.resignFirstResponder()
        if inputTextField.inputView == nil {
            inputTextField.inputView = emoticonV
            inputTextField.backgroundColor = UIColor.clear
        }else {
            inputTextField.inputView = nil
        }
        inputTextField.becomeFirstResponder()
        inputTextField.selectedTextRange = range
    }
}
