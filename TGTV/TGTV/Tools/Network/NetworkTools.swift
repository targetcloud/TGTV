//
//  NetworkTools.swift
//  TGPageView
//
//  Created by targetcloud on 2017/3/26.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

//原来1
import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTools {
    static let share : NetworkTools = NetworkTools()
    
    private init(){}
    
    //参数的finishedCallback闭包在26行使用了，而使用的环境又是一个闭包，则需要加@escaping
    func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? " --- 网络请求发生了错误 --- ")
                return
            }
            finishedCallback(result)
        }
    }
}
