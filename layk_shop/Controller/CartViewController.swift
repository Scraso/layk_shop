//
//  CartViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/25/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
    }

}

extension CartViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cart.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        if indexPath.section == 0 {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemsCell
            let item = cart[indexPath.row]
            itemCell.nameLbl.text = item["name"]
            itemCell.itemImageView.image = UIImage(named: item["itemImageView"]!)
            itemCell.countLbl.text = item["count"]
            itemCell.refLbl.text = item["ref"]
            itemCell.priceLbl.text = item["price"]
            return itemCell
        }
        let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalCell
        totalCell.amountLbl.text = "4500 грн"
        return totalCell
        
    }
    
}
