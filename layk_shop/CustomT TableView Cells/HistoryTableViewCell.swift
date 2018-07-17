//
//  HistoryTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/19/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import SDWebImage

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var refLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    func configureCell(data: ItemData, sectionName: String) {
        self.countLbl.text = "Количество: \(data.count ?? 0)"
        self.costLbl.text = "\(data.price ?? 0) грн"
        self.nameLbl.text = "\(data.name ?? "") (\(data.size ?? ""))"
        self.refLbl.text = "Код товара: \(data.ref ?? "")"
        
        let itemData = Date(timeIntervalSince1970: data.timestamp!)
        timestampLbl.text = itemData.formattedTableViewString()
        
        let placeHolderImage = #imageLiteral(resourceName: "promotion_placeholder")
        avatarImageView.sd_setShowActivityIndicatorView(true)
        avatarImageView.sd_setIndicatorStyle(.gray)
        avatarImageView.sd_setImage(with: URL(string: data.avatarImageUrl ?? ""), placeholderImage: placeHolderImage)
    
        
        if sectionName == "В обработке" {
            statusView.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 100)
        }
        if sectionName == "В ожидании отправки" {
            statusView.backgroundColor = UIColor.init(red: 88/255, green: 86/255, blue: 214/255, alpha: 100)
        }
        if sectionName == "Отправлен" {
            statusView.backgroundColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 100)
        }
        if sectionName == "Получен" {
            statusView.backgroundColor = UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 100)
        }
        
    }
    

}
