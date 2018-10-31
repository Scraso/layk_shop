//
//  OrderHistoryViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 10/29/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        navigationItem.title = "Мои заказы"
    }
    
}

extension OrderHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell", for: indexPath) as? OrderHistoryTableViewCell
        return cell!
        
    }
    
    
}

extension OrderHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? OrderHistoryTableViewCell {
            cell.collectionView.dataSource = self
        }
    }
}

extension OrderHistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionView = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageCell", for: indexPath)
        return collectionView
    }
    
    
}
