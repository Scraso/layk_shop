//
//  ItemListData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/3/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation


struct ItemListData {
    
    var name: String?
    var price: Int?
    var isAvailable: Bool? = false
    var avatarImageUrl: String?
    var itemDetails = [String]()
    var imageURLs = [String]()
    var documentId: String?
    var itemSizes = [String: Int]()
    
    
    init(data: Dictionary<String, Any>, documentId: String?) {
        
        self.documentId = documentId
        
        if let name = data["name"] as? String {
            self.name = name
        }
        if let price = data["price"] as? Int {
            self.price = price
        }
        if let isAvailable = data["isAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
        if let avatarImageUrl = data["avatarImageURL"] as? String {
            self.avatarImageUrl = avatarImageUrl
        }
        if data["itemDetails"] != nil {
            if let itemData = data["itemDetails"] as? NSArray {
                self.itemDetails = (itemData as? [String])!
            }
        }
        if let sizeDictionary = data["size"] as? [String: Int] {
            self.itemSizes = sizeDictionary
        }        
        if data["images"] != nil {
            if let imgData = data["images"] as? NSArray {
                self.imageURLs = (imgData as? [String])!
            }
        }
    }
}
