//
//  ShopViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import Firebase
import Reachability
import NVActivityIndicatorView

class ShopViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var categories = [ShopData]()
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballClipRotateMultiple, color: UIColor.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 11.0, *) {
            tableView.insetsContentViewsToSafeArea = true
        }
        
        fetchShopCategory()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove selection when back to ViewController
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        
        // Check and set status network initially once Tab Bar Controller is shown since App Delegate will not trigger again
        // untill Network will be updated again
        networkStatusDidChange(status: ReachabilityManager.shared.reachabilityStatus)
        
        // Add Network status listener
        ReachabilityManager.shared.addListener(listener: self)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove Network status listener
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    // MARK: - Helpers
    
    fileprivate func updateNetworkTitleStatus() {
        navigationItem.title = "Магазин"
        navigationItem.titleView = nil
    }
    
    // MARK: - API CALL
    
    fileprivate func fetchShopCategory() {
        
        DataService.instance.REF_SHOP_CATEGORY.whereField("isEnabled", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.categories = []
            
            guard let snapshot = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach({ (diff) in
                if (diff.type == .added) {
                    let data = ShopData(data: diff.document.data())
                    self?.categories.append(data)
                }
            })
            self?.tableView.reloadData()
        }
    }
    
}

extension ShopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.productName
        return cell
    }
}

extension ShopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "Items", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Items" {
            if let destination = segue.destination as? ItemsTableViewController {
                let indexPath = tableView.indexPathForSelectedRow
                let currentCell = tableView.cellForRow(at: indexPath!)
                destination.categoryTitle = currentCell?.textLabel?.text
                
                // Hardcoded back button title to prevent issue when due to Network connection
                // the title is changed to 'Ожидание сети" therefore back button title is wrong
                let backItem = UIBarButtonItem()
                backItem.title = "Магазин"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
    
}

extension ShopViewController: NetworkStatusListener {

    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .wifi:
            updateNetworkTitleStatus()
            print("Reachable via WiFi")
        case .cellular:
            updateNetworkTitleStatus()
            print("Reachable via Cellular")
        case .none:
            navigationItem.title = "Ожидание сети"
            navigationItem.titleView = activityIndicator
            activityIndicator.startAnimating()
            print("Network not reachable")
        }
    }
}
