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
    var imageName: String?
    var itemDetails = [String]()
    var xsSize: Int?
    var xlSize: Int?
    var sSize: Int?
    var mSize: Int?
    var lSize: Int?
    var imageURLs = [String]()
    
    init(data: Dictionary<String, Any>) {
        if let name = data["name"] as? String {
            self.name = name
        }
        if let price = data["price"] as? Int {
            self.price = price
        }
        if let isAvailable = data["isAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
        if let imageName = data["avatarImageURL"] as? String {
            let name = imageName.slice(from: "itemList-images/", to: ".jpg")
            self.imageName = name
        }
        
        if data["itemDetails"] != nil {
            if let itemData = data["itemDetails"] as? NSArray {
                self.itemDetails = (itemData as? [String])!
            }
        }
        
        if let nestedDictionary = data["size"] as? [String: Any] {
            if let xsSize = nestedDictionary["XS"] as? Int {
                self.xsSize = xsSize
            }
            if let xlSize = nestedDictionary["XL"] as? Int {
                self.xlSize = xlSize
            }
            if let sSize = nestedDictionary["S"] as? Int {
                self.sSize = sSize
            }
            if let mSize = nestedDictionary["M"] as? Int {
                self.mSize = mSize
            }
            if let lSize = nestedDictionary["L"] as? Int {
                self.lSize = lSize
            }
        }
        
        if data["images"] != nil {
            if let imgData = data["images"] as? NSArray {
                self.imageURLs = (imgData as? [String])!
            }
        }
    }
}
