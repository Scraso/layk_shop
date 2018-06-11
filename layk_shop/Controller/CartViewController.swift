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
    @IBOutlet weak var nextBtn: UIButton!
    
    var items = [CartData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    @IBAction func nextBtnTapped(_ sender: UIButton) {
    }
}

extension CartViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemsCell
            let item = items[indexPath.row]
            itemCell.nameLbl.text = item.name
            itemCell.priceLbl.text = "\(item.price ?? 0) грн"
            itemCell.refLbl.text = item.ref
            itemCell.sizeLbl.text = item.size
            itemCell.itemImageView.image = item.itemImageView
            //            let item = cart[indexPath.row]
            //            itemCell.nameLbl.text = item["name"]
            //            itemCell.itemImageView.image = UIImage(named: item["itemImageView"]!)
            //            itemCell.countLbl.text = item["count"]
            //            itemCell.refLbl.text = item["ref"]
            //            itemCell.priceLbl.text = item["price"]
            return itemCell
        }
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            // Add label wich says there is no items in the cart
            print("No items in the cart")
            nextBtn.isHidden = true
        } else {
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalCell
            
            let cost = items.reduce(0, { (result, cartData) -> Int in
                var value = 0
                value += cartData.price ?? 0
                return result + value
                
            })
            totalCell.amountLbl.text = String("\(cost) грн")
            nextBtn.isHidden = false
            return totalCell
        }
        return UITableViewCell()
    }
    
}
