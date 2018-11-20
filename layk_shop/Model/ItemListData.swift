//
//  ItemListData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/3/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct ItemListData {
    
    var name: String
    var price: Int
    var isAvailable: Bool
    var avatarImageUrl: String
    var itemDetails = [String]()
    var imageURLs = [String]()
    var documentId: String
    var itemSizes = [String: Int]()
    var code: String
    var timestamp: Double
    
}

extension ItemListData {
    
    init?(data: [String: Any], documentId: String) {
        let name = data["name"] as? String ?? ""
        let price = data["price"] as? Int ?? 0
        let isAvailable = data["isAvailable"] as? Bool ?? false
        let avatarImageUrl = data["avatarImageURL"] as? String ?? ""
        let code = data["code"] as? String
        let sizeDictionary = data["size"] as? [String: Int]
        let itemData = data["itemDetails"] as? NSArray
        let imgData = data["images"] as? NSArray
        
        let timestamp = data["timestamp"] as? Timestamp
        let date = timestamp?.dateValue()
        let timeInterval = date?.timeIntervalSince1970 ?? 0.0
        
        self.init(name: name, price: price, isAvailable: isAvailable, avatarImageUrl: avatarImageUrl, itemDetails: itemData as? [String] ?? [""], imageURLs: imgData as? [String] ?? [""], documentId: documentId, itemSizes: sizeDictionary ?? ["": 0], code: code ?? "", timestamp: timeInterval)
    }
}
