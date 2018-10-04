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
    private var _REF_NEWS_SECTION_HEADER = DB_BASE.collection("news_section_header")
    private var _REF_NEWS_SECTION_PARAGRAPHS = DB_BASE.collection("news_section_paragraphs")
    
    
    private var _REF_SHOP_CATEGORY = DB_BASE.collection("shop_category")
    private var _REF_ITEMS = DB_BASE.collection("items")
    private var _REF_ORDERS = DB_BASE.collection("orders")
    
    // TOKENS
    private var _REF_FCM_TOKEN_REGISTERED_USERS = DB_BASE.collection("fcmToken_registered_users")
    private var _REF_FCM_TOKEN_ALL = DB_BASE.collection("fcmToken_all")
    private var _REF_BADGES_COUNT_DETAILS = DB_BASE.collection("badge_count_details")
    private var _REF_BADGE_COUNT_TOTAL = DB_BASE.collection("badge_count_total")
    
    private var _REF_ORDER_STATUS = DB_BASE.collection("order_status")
    
    private var _REF_USERS = DB_BASE.collection("users")
    private var _REF_ORDER_DELIVERY_DETAILS = DB_BASE.collection("order_delivery_details")
    private var _REF_TESTIMONIALS = DB_BASE.collection("testimonials")
    
    // Storage reference
    
    private var _REF_NEWS_IMAGES = DB_STORAGE.child("news-images")
    private var _REF_ITEMLIST_IMAGES = DB_STORAGE.child("itemList-images")
    private var _REF_PAGECONTROL_IMAGES = DB_STORAGE.child("pageControl-images")
    private var _REF_TESTIMONIAL_IMAGES = DB_STORAGE.child("testimonial-images")
    

    var REF_NEWS_IMAGES: StorageReference {
        return _REF_NEWS_IMAGES
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
    
    var REF_NEWS_SECTION_HEADER: CollectionReference {
        return _REF_NEWS_SECTION_HEADER
    }
    
    var REF_NEWS_SECTION_PARAGRAPHS: CollectionReference {
        return _REF_NEWS_SECTION_PARAGRAPHS
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
    
    var REF_FCM_TOKEN_REGISTERED_USERS: CollectionReference {
        return _REF_FCM_TOKEN_REGISTERED_USERS
    }
    
    var REF_FCM_TOKEN_ALL: CollectionReference {
        return _REF_FCM_TOKEN_ALL
    }
    
    var REF_BADGE_COUNT_TOTAL: CollectionReference {
        return _REF_BADGE_COUNT_TOTAL
    }
    
    var REF_BADGE_COUNT_DETAILS: CollectionReference {
        return _REF_BADGES_COUNT_DETAILS
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
    
    var REF_ORDER_STATUS: CollectionReference {
        return _REF_ORDER_STATUS
    }
    
    
}
