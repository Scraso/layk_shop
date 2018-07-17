//
//  ItemsTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseUI
import SDWebImage

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var descriptionFirstLbl: UILabel!
    @IBOutlet weak var descriptionSecondLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var availabilityLbl: UILabel!
    
    
    // Items will be loaded based on the category selected (see DB category key)
    func configureCell(data: ItemListData) {
        itemNameLbl.text = data.name
        priceLbl.text = "\(data.price ?? 0) грн"
        
        
        // Check the total Items size count
        let totalSizeCount = data.itemSizes.reduce(0) { (result, data) -> Int in
            return result + data.value
        }
        
        if totalSizeCount <= 0 {
            availabilityLbl.text = "Нет в наличии"
            availabilityLbl.textColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 100)
        } else {
            availabilityLbl.text = "Есть в наличии"
            availabilityLbl.textColor = UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 100)
        }
        
        let placeHolderImage = #imageLiteral(resourceName: "promotion_placeholder")
        itemImageView.sd_setShowActivityIndicatorView(true)
        itemImageView.sd_setIndicatorStyle(.gray)
        itemImageView.sd_setImage(with: URL(string: data.avatarImageUrl ?? ""), placeholderImage: placeHolderImage)
        
        descriptionFirstLbl.text = data.itemDetails[exist: 0]
        descriptionSecondLbl.text = data.itemDetails[exist: 1]
    }

}
