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
    var status: String?
    var name: String?
    var price: Int?
    var ref: String?
    var size: String?
    var timestamp: Double?
    
    var orderId: String?
    var isChecked: Bool?
    
    // Possible variables
//    var userId: String?
//    var itemDocumentId: String?
    
    init(itemData: Dictionary<String, Any>) {
        if let count = itemData["count"] as? Int {
            self.count = count
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
        if let orderId = itemData["orderId"] as? String {
            self.orderId = orderId
        }
        if let isChecked = itemData["isChecked"] as? Bool {
            self.isChecked = isChecked
        }
        if let status = itemData["status"] as? String {
            self.status = status
        }

    }
    
}

struct HistoryOrderData {
    var sectionName: String
    var orders: [ItemData]
    
}
