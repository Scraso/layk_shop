//
//  ShopViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import Firebase

class ShopViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var categories = [ShopData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 11.0, *) {
            tableView.insetsContentViewsToSafeArea = true
        }
        
        fetchShopCategory()

    }
    
    // Remove selection when back to ViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    // MARK: - API CALL
    
    fileprivate func fetchShopCategory() {
        DataService.instance.REF_SHOP_CATEGORY.whereField("isEnabled", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
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
            }
        }
    }
    
}
