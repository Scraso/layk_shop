//
//  ShopData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/1/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct ShopData {
    
    var productName: String?
    
    init(data: Dictionary<String, Any>) {
        if let productName = data["name"] as? String {
            self.productName = productName
        }
    }
 
}


