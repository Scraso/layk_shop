//
//  HistorySectionData.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/13/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import Foundation

struct HistorySectionData {
    
    var avatarImageUrl: String
    var bodyText: String
    var content: String
    var title: String
    var imageUrl: String
    var documentId: String
    
    var bodyDictionary: [String: Any] {
        return [
            "text": bodyText
        ]
    }
    var mediaDictionary: [String: Any] {
        return [
            "content": content,
            "title": title,
            "imageUrl": imageUrl
        ]
    }
}

extension HistorySectionData {
    
    init?(dictionary: [String: Any], avatarImageUrl: String, bodyText: String, documentId: String) {
        let content = dictionary["content"] as? String
        let imageUrl = dictionary["imageUrl"] as? String
        let title = dictionary["title"] as? String
        
        self.init(avatarImageUrl: avatarImageUrl, bodyText: bodyText , content: content ?? "", title: title ?? "", imageUrl: imageUrl ?? "", documentId: documentId)
    }
    
}

extension HistorySectionData: Equatable {
    static func == (lhs: HistorySectionData, rhs: HistorySectionData) -> Bool {
        return lhs.avatarImageUrl == rhs.avatarImageUrl && lhs.documentId == rhs.documentId
    }
}
