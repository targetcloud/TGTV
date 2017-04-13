//
//  Bundle+extension.swift
//  TGTV
//
//  Created by targetcloud on 2017/4/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

import Foundation

extension Bundle {
    var nameSpace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
