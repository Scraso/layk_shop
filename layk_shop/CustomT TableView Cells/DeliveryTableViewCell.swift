//
//  DeliveryTableViewCell.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/26/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var detailsTextField: UITextField!
    
    var details: [String: Any]?

    override func layoutSubviews() {
        super.layoutSubviews()

        if let details = details {
            switch detailsTextField.tag {
            case 0:
                if let name = details["name"] as? String {
                    self.detailsTextField.text = name
                }
            case 1:
                if let phone = details["phone"] as? String {
                    self.detailsTextField.text = phone
                }
            case 2:
                if let city = details["city"] as? String {
                    self.detailsTextField.text = city
                }
            case 3:
                if let address = details["address"] as? String {
                    self.detailsTextField.text = address
                }
            default:
                break
            }
        }
    }

}

class CommentCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var commentTextView: UITextView!
    

}


