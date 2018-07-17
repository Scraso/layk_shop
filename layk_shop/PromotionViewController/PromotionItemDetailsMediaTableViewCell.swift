//
//  PromotionItemDetailsMediaTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/10/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PromotionItemDetailsMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UITextView!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    func configureCell(data: HistorySectionDataDetails) {
        self.titleLbl.text = data.title
        self.bodyLbl.text = data.content
        let placeholderImage = #imageLiteral(resourceName: "promotion_placeholder")
        mediaImageView.sd_setShowActivityIndicatorView(true)
        mediaImageView.sd_setIndicatorStyle(.gray)
        mediaImageView.sd_setImage(with: URL(string: data.imageUrl), placeholderImage: placeholderImage)
        
    }
    
}
