//
//  ShippingTableViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/24/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ShippingTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Доставка и оплата"
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShippingCell", for: indexPath)
        return cell
    }
    
    // Mark: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebVC" {
            let toNav = segue.destination as! UINavigationController
            let toVC = toNav.viewControllers.first as! WebViewController
            toVC.urlString = sender as! String
        }
    }
    
    // MARK: - Actions
    
    @IBAction func instagramBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toWebVC", sender: "https://www.instagram.com/laykwear/")
    }
    
    @IBAction func facebookBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toWebVC", sender: "https://www.facebook.com/laykwear/")
    }
    

}
