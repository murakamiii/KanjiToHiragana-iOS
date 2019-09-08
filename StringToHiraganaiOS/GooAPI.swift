//
//  GooAPI.swift
//  StringToHiraganaiOS
//
//  Created by murakami Taichi on 2019/09/09.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation

class GooAPI {
    static let api_key = gooAPIKeyFromPlist() ?? ProcessInfo.processInfo.environment["goo_id"]

    private static func gooAPIKeyFromPlist() -> String? {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
            let ndic = NSDictionary.init(contentsOfFile: path),
            let value = ndic["goo_id"] as? String {
            return value
        }
        return nil
    }
}
