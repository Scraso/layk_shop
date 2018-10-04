//
//  FCMTokenData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 9/9/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct FCMToken {
    
    var token: String?
    
    init(data: Dictionary<String, Any>) {
        if let token = data["token"] as? String {
            self.token = token
        }
    }
}
