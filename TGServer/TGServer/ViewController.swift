//
//  ViewController.swift
//  TGServer
//
//  Created by targetcloud on 2017/3/27.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var tipLabel: NSTextField!
    @IBOutlet weak var stopBtn: NSButton!
    
    fileprivate lazy var mgr : IMServerManager = IMServerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopBtn.isEnabled = false
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startRunning(_ sender: NSButton) {
        tipLabel.stringValue = "正在监听客户端连接请求。。。"
        mgr.startRunning("0.0.0.0", 9898)
        stopBtn.isEnabled = true
        startBtn.isEnabled = false
    }
    
    
    @IBAction func stopRunning(_ sender: NSButton) {
        tipLabel.stringValue = "停止监听新的客户端连接请求。"
        mgr.stopRunning()
        stopBtn.isEnabled = false
    }

}

