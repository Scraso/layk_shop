//
//  HistoryTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/19/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseUI
import SDWebImage

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var refLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    func configureCell(data: ItemData) {
        self.countLbl.text = "Количество: \(data.count ?? 0)"
        self.costLbl.text = "\(data.price ?? 0) грн"
        self.nameLbl.text = "\(data.name ?? "") (\(data.size ?? ""))"
        self.refLbl.text = "Код товара: \(data.ref ?? "")"
        
        let itemData = Date(timeIntervalSince1970: data.timestamp!)
        timestampLbl.text = itemData.formattedTableViewString()
        
        let ref = DataService.instance.REF_ITEMLIST_IMAGES.child("\(data.avatarName ?? "").jpg")
        let placeHolderImage = #imageLiteral(resourceName: "promotion_placeholder")
        avatarImageView.sd_setShowActivityIndicatorView(true)
        avatarImageView.sd_setIndicatorStyle(.gray)
        avatarImageView.sd_setImage(with: ref, placeholderImage: placeHolderImage)
        
    }
    

}
