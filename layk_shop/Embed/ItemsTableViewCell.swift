//
//  ItemsTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var descriptionFirstLbl: UILabel!
    @IBOutlet weak var descriptionSecondLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var availabilityLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
