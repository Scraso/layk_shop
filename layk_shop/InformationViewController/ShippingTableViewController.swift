//
//  ShippingTableViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ShippingTableViewController: UITableViewController {
    
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Доставка и оплата"
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        fetchShippingInformation()
    }
    
    // MARK: - API CALL
    fileprivate func fetchShippingInformation() {
        DataService.instance.REF_SHIPPING.addSnapshotListener { (documentSnapshot, error) in
            
            guard let document = documentSnapshot?.data() else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if let text = document["text"] as? String {
                self.text = text
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingCell", for: indexPath)
        cell.textLabel?.text = text ?? ""
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    // Mark: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }


}
