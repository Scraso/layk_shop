//
//  ItemsTableViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var categoryTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = categoryTitle ?? ""
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsTableViewCell
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.itemImageView.image = UIImage(named: item["image"]!)
        cell.descriptionFirstLbl.text = item["composition_1"]
        cell.descriptionSecondLbl.text = item["composition_2"]
        cell.itemNameLbl.text = item["name"]
        cell.availabilityLbl.text = item["status"]
        cell.priceLbl.text = item["price"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemDetails", sender: self)
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }

}
