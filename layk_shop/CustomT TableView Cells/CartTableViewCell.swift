//
//  CartTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/27/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var refLbl: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBAction func minutBtnTapped(_ sender: UIButton) {
    }
    @IBAction func plusBtnTapped(_ sender: UIButton) {
    }
}

class TotalCell: UITableViewCell {
    
    @IBOutlet weak var amountLbl: UILabel!
    
}
