//
//  DataCountListenerService.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 10/3/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore

protocol DataCountListenerDelegate: class {
    func historyBadgeCount(count: Int)
    func appBadgeCount(count: Int)
}

class DataCountListenerService {
    
    private static let _instance = DataCountListenerService()
    static var instance: DataCountListenerService {
        return _instance
    }
    
    weak var delegate: DataCountListenerDelegate? = nil

    // Add listeners to listen for Counter changes
    func fetchHistoryBadgeCount() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_BADGE_COUNT_DETAILS.document("history_badges_count").collection("badgeCount").document(currentUserUid).addSnapshotListener { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if let documentData = document.data() {
                if let count = documentData["count"] as? Int {
                    if self.delegate != nil {
                        self.delegate?.historyBadgeCount(count: count)
                    }
                }
            }
        }
    }
    
    func fetchAppIconCount() {
        DataService.instance.REF_BADGE_COUNT_TOTAL.document(Messaging.messaging().fcmToken ?? "none").addSnapshotListener { (documentSnapshot, error) in
            
            guard let document = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if let documentData = document.data() {
                if let count = documentData["count"] as? Int {
                    if self.delegate != nil {
                        self.delegate?.appBadgeCount(count: count)
                    }
                }
            }
            
        }
    }
}
