//
//  DataService.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/30/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation
import Firebase

// Database URL
let DB_BASE = Firestore.firestore()
let DB_STORAGE = Storage.storage().reference()

class DataService {
    
    private static let _instance = DataService()
    static var instance: DataService {
        return _instance
    }
    
    // Firestore reference
    private var _REF_PROMOTION_SECTION = DB_BASE.collection("history_section")
    private var _REF_PROMOTION_SECTION_MEDIA = DB_BASE.collection("history_section_media")
    private var _REF_SHOP_CATEGORY = DB_BASE.collection("shop_category")
    private var _REF_ITEMS = DB_BASE.collection("items")
    private var _REF_ORDERS = DB_BASE.collection("orders")
    private var _REF_FCM_TOKEN = DB_BASE.collection("fcmToken")
    private var _REF_USER_BADGE_COUNT = DB_BASE.collection("userBadgeCount")
    private var _REF_USERS = DB_BASE.collection("users")
    private var _REF_ORDER_DELIVERY_DETAILS = DB_BASE.collection("order_delivery_details")
    private var _REF_TESTIMONIALS = DB_BASE.collection("testimonials")
    
    // Storage reference
    private var _REF_PROMOTION_IMAGES = DB_STORAGE.child("history-images")
    private var _REF_ITEMLIST_IMAGES = DB_STORAGE.child("itemList-images")
    private var _REF_PAGECONTROL_IMAGES = DB_STORAGE.child("pageControl-images")
    private var _REF_TESTIMONIAL_IMAGES = DB_STORAGE.child("testimonial-images")
    
    var REF_PROMOTION_IMAGES: StorageReference {
        return _REF_PROMOTION_IMAGES
    }
    
    var REF_ITEMLIST_IMAGES: StorageReference {
        return _REF_ITEMLIST_IMAGES
    }
    
    var REF_PAGECONTROL_IMAGES: StorageReference {
        return _REF_PAGECONTROL_IMAGES
    }
    
    var REF_TESTIMONIAL_IMAGES: StorageReference {
        return _REF_TESTIMONIAL_IMAGES
    }
    
    var REF_PROMOTION_SECTION: CollectionReference {
        return _REF_PROMOTION_SECTION
    }
    
    var REF_PROMOTION_SECTION_MEDIA: CollectionReference {
        return _REF_PROMOTION_SECTION_MEDIA
    }
    
    var REF_SHOP_CATEGORY: CollectionReference {
        return _REF_SHOP_CATEGORY
    }
    
    var REF_ITEMS: CollectionReference {
        return _REF_ITEMS
    }
    

    var REF_ORDERS: CollectionReference {
        return _REF_ORDERS
    }
    
    var REF_FCM_TOKEN: CollectionReference {
        return _REF_FCM_TOKEN
    }
    
    var REF_USER_BADGE_COUNT: CollectionReference {
        return _REF_USER_BADGE_COUNT
    }
    
    var REF_USERS: CollectionReference {
        return _REF_USERS
    }

    var REF_ORDER_DELIVERY_DETAILS: CollectionReference {
        return _REF_ORDER_DELIVERY_DETAILS
    }
    
    var REF_TESTIMONIALS: CollectionReference {
        return _REF_TESTIMONIALS
    }
    
    
}
