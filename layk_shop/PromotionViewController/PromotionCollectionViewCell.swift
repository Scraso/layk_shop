//
//  PromotionCollectionViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/19/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    func configureCell(data: HistorySectionData) {
        let placeholderImage = #imageLiteral(resourceName: "promotion_placeholder")
        backgroundImageView?.sd_setShowActivityIndicatorView(true)
        backgroundImageView?.sd_setIndicatorStyle(.gray)
        backgroundImageView?.sd_setImage(with: URL(string: data.avatarImageUrl), placeholderImage: placeholderImage)
        titleLbl.text = data.title
        
    }
    
}

