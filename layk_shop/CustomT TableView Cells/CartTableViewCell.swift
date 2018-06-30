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
    @IBOutlet weak var deleteItemBtn: UIButton!
    
    
    var deleteButtonTapped: ((UIButton) -> Void)? = nil
    var countButtonTapped: ((Int) -> Void)? = nil
   
    @IBAction func minutBtnTapped(_ sender: UIButton) {
        if let countButtonTapped = countButtonTapped {
            countButtonTapped(1)
        }
    }
    
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        if let countButtonTapped = countButtonTapped {
            countButtonTapped(2)
        }
    }
    @IBAction func deleteBtnTapped(_ sender: UIButton) {
        if let onButtonTapped = self.deleteButtonTapped {
           onButtonTapped(sender)
        }
    }
    
}

class TotalCell: UITableViewCell {
    
    @IBOutlet weak var amountLbl: UILabel!
    
}
