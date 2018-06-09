//
//  ItemsTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseStorageUI
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
        if data.isAvailable == true {
            availabilityLbl.text = "Есть в наличии"
            availabilityLbl.textColor = UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 100)
        } else {
            availabilityLbl.text = "Нету в наличии"
            availabilityLbl.textColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 100)
        }
        
        let ref = DataService.instance.REF_ITEMLIST_IMAGES.child("\(data.imageName ?? "").jpg")
        let placeHolderImage = #imageLiteral(resourceName: "promotion_placeholder")
        itemImageView.sd_setShowActivityIndicatorView(true)
        itemImageView.sd_setIndicatorStyle(.gray)
        itemImageView.sd_setImage(with: ref, placeholderImage: placeHolderImage)
        
        descriptionFirstLbl.text = data.itemDetails[0]
        descriptionSecondLbl.text = data.itemDetails[1]
    }

}
