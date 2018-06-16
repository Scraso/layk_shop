//
//  DeliveryViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/25/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class DeliveryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        navigationItem.title = "Доставка"
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addTextViewPlaceholder(textView: UITextView, placeholderLbl: UILabel) {
        placeholderLbl.text = "Комментарий к заказу"
        placeholderLbl.font = UIFont.italicSystemFont(ofSize: 17)
        placeholderLbl.sizeToFit()
        textView.addSubview(placeholderLbl)
        placeholderLbl.frame.origin = CGPoint(x: 5, y: 10)
        placeholderLbl.textColor = UIColor.init(red: 202/255, green: 202/255, blue: 207/255, alpha: 100)
        textView.isHidden = !textView.text.isEmpty

    }
    
}

extension DeliveryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            addTextViewPlaceholder(textView: cell.commentTextView, placeholderLbl: cell.placeholderLbl)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        switch indexPath.row {
        case 0:
            cell.detailsTextField.placeholder = "Ф.И.О"
        case 1:
            cell.detailsTextField.placeholder = "Номер телефона"
        case 2:
            cell.detailsTextField.placeholder = "Город"
        case 3:
            cell.detailsTextField.placeholder = "Отделение Новой Почты"
        default:
            break
        }
        return cell
        
    }
    
}
