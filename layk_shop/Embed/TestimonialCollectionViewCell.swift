//
//  TestimonialCollectionViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class TestimonialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testimonialLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configureCell(testimonials: TestimonialData) {
        self.testimonialLbl.text = testimonials.text ?? ""
        self.nameLbl.text = testimonials.name ?? ""
        
        let placeHolderImage = #imageLiteral(resourceName: "promotion_placeholder")
        avatarImageView.sd_setShowActivityIndicatorView(true)
        avatarImageView.sd_setIndicatorStyle(.gray)
        avatarImageView.sd_setImage(with: URL(string: testimonials.imageUrl ?? ""), placeholderImage: placeHolderImage)
        
    }
    
}
