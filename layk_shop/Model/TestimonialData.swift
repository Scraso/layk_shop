//
//  TestimonialData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/30/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct TestimonialData {
    
    var text: String?
    var name: String?
    var imageUrl: String?
    
    init(dictionary: Dictionary<String, Any>) {
        if let text = dictionary["text"] as? String {
            self.text = text
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
    }
    
}
