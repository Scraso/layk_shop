//
//  CartData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/8/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation
import UIKit

struct CartData {

    let price: Int?
    let name: String?
    let ref: Int
    let size: String?
    var count: Int
    let documentId: String?
    let itemImageView: UIImage?
    let itemName: String?
    
}

//func ==(lhs: CartData, rhs: CartData) -> Bool {
//    return lhs.name == rhs.name && lhs.size == rhs.size
//}

