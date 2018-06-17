//
//  ItemsTableViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseFirestore


class ItemsTableViewController: UITableViewController {
    
    var categoryTitle: String?
    
    var itemList = [ItemListData]()
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = categoryTitle ?? ""
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        fetchItemList()
    }
    
    deinit {
        listener.remove()
        print("ItemTableViewController has been deinitialized")
    }
    
    // MARK: - API CALL
    
    func fetchItemList() {
        listener = DataService.instance.REF_ITEMS.whereField("category", isEqualTo: categoryTitle ?? "").addSnapshotListener({ [weak self] (documentSnapshot, error) in
            guard let snapshot = documentSnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach({ (diff) in
                if (diff.type == .added) {
                    let data = ItemListData(data: diff.document.data(), documentId: diff.document.documentID)
                    self?.itemList.append(data)
                }
            })
            self?.tableView.reloadData()
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetails" {
            if let destination = segue.destination as? ItemDetailsViewController {
                if let itemData = sender as? ItemListData {
                    destination.itemDetails = itemData
                }
                // Delegate Image View
                destination.itemImageView = itemImageView
            }
        }
    }
    

    // MARK: - TableView DataSource
    
    var itemImageView: UIImage?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsTableViewCell
        cell.selectionStyle = .none
        let item = itemList[indexPath.row]
        cell.configureCell(data: item)
        // Save item imageView to delegate to Details View Controller
        itemImageView = cell.itemImageView.image
        
        return cell
    }

    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemList[indexPath.row]
        performSegue(withIdentifier: "ItemDetails", sender: item)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.Magnitude.leastNonzeroMagnitude
    }

}
