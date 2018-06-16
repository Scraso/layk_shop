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
    
}

class CommentCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var commentTextView: UITextView!
    let placeholderLbl = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commentTextView.delegate = self

    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLbl.isHidden = !textView.text.isEmpty
        
        // Adjust height of the row based on textView height
        let currentOffset = parentTableView()?.contentOffset
        UIView.setAnimationsEnabled(false)
        parentTableView()?.beginUpdates()
        parentTableView()?.endUpdates()
        UIView.setAnimationsEnabled(true)
        parentTableView()?.setContentOffset(currentOffset!, animated: false)
        
    }
    
}

// Access Parent View (TableView)
extension UIView {
    func parentTableView() -> UITableView? {
        var viewOrNil: UIView? = self
        while let view = viewOrNil {
            if let tableView = view as? UITableView {
                return tableView
            }
            viewOrNil = view.superview
        }
        return nil
    }
}
