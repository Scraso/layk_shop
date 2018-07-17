//
//  HistoryOrderData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct ItemData {
    
    var avatarImageUrl: String?
    var count: Int?
    var isProcessed: Bool?
    var isDelivered: Bool?
    var isSent: Bool?
    var name: String?
    var price: Int?
    var ref: String?
    var size: String?
    var timestamp: Double?
    
    // Possible variables
//    var userId: String?
//    var itemDocumentId: String?
    
    init(itemData: Dictionary<String, Any>) {
        if let count = itemData["count"] as? Int {
            self.count = count
        }
        if let isProcessed = itemData["isProcessed"] as? Bool {
            self.isProcessed = isProcessed
        }
        if let isDelivered = itemData["isDelivered"] as? Bool {
            self.isDelivered = isDelivered
        }
        if let isSent = itemData["isSent"] as? Bool {
            self.isSent = isSent
        }
        if let avatarImageUrl = itemData["avatarImageUrl"] as? String {
            self.avatarImageUrl = avatarImageUrl
        }
        if let name = itemData["name"] as? String {
            self.name = name
        }
        if let ref = itemData["ref"] as? String {
            self.ref = ref
        }
        if let size = itemData["size"] as? String {
            self.size = size
        }
        if let price = itemData["price"] as? Int {
            self.price = price
        }
        if let timestamp = itemData["timestamp"] as? Double {
            self.timestamp = timestamp
        }
    }
    
}

struct HistoryOrderData {
    var sectionName: String
    var orders: [ItemData]
    
}
