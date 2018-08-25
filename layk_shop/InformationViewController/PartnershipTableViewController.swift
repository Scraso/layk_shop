//
//  PartnershipTableViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PartnershipTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Сотрудничество"
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnershipCell", for: indexPath)
        return cell
    }
    
    // Mark: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }
    
    // MARK: - Actions
    
    @IBAction func telNumberBtnTapped(_ sender: UIButton) {
        let url = URL(string: "tel://\(sender.titleLabel?.text ?? "")")!
        UIApplication.shared.open(url as URL)
    }
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        let url = URL(string: "mailto:\(sender.titleLabel?.text ?? "")")!
        UIApplication.shared.open(url as URL)
    }
    
    

}
