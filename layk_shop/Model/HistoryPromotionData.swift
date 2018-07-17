//
//  HistorySectionData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/13/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct HistorySectionData {
    
    var avatarImageUrl: String
    var bodyText: String
    var documentId: String
    
}

extension HistorySectionData {
    
    init?(dictionary: [String: Any], documentId: String) {
        let avatarImageUrl = dictionary["avatarImageUrl"] as? String ?? ""
        let bodyText = dictionary["body_text"] as? String ?? ""
        
        self.init(avatarImageUrl: avatarImageUrl, bodyText: bodyText, documentId: documentId)
    }
    
}

struct HistorySectionDataDetails {
    
    var title: String
    var content: String
    var imageUrl: String
    var timestamp: Double
    
}

extension HistorySectionDataDetails {
    
    init?(dictionary: [String: Any]) {
        let title = dictionary["title"] as? String ?? ""
        let content = dictionary["content"] as? String ?? ""
        let imageUrl = dictionary["imageUrl"] as? String ?? ""
        let timestamp = dictionary["timestamp"] as? Timestamp
        let date = timestamp?.dateValue()
        let timeInterval = date?.timeIntervalSince1970 ?? 0.0
        self.init(title: title, content: content, imageUrl: imageUrl, timestamp: timeInterval)
    }

}

extension HistorySectionData: Equatable {
    static func == (lhs: HistorySectionData, rhs: HistorySectionData) -> Bool {
        return lhs.avatarImageUrl == rhs.avatarImageUrl && lhs.documentId == rhs.documentId
    }
}
