//
//  OrderStatusData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 9/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct OrderStatusData {
    var userId: String?
    var orderId: String?
    var isProcessed: Bool?
    var isSent: Bool?
    var isDelivered: Bool?
    
    init(documentData: Dictionary<String, Any>) {
        if let userId = documentData["userId"] as? String {
            self.userId = userId
        }
        if let orderId = documentData["orderId"] as? String {
            self.orderId = orderId
        }
        if let isProcessed = documentData["isProcessed"] as? Bool {
            self.isProcessed = isProcessed
        }
        if let isSent = documentData["isSent"] as? Bool {
            self.isSent = isSent
        }
        if let isDelivered = documentData["isDelivered"] as? Bool {
            self.isDelivered = isDelivered
        }
    }
}
