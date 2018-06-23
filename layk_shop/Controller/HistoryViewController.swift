//
//  HistoryViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/18/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var listener: ListenerRegistration!
    
    var onProcessing = [ItemData]()
    var onProcessOfSending = [ItemData]()
    var sentItem = [ItemData]()
    var completed = [ItemData]()

    var historyOrderArray = [HistoryOrderData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.fetchOrders {
                    self.historyOrderArray = [HistoryOrderData(sectionName: "В Обработке", orders: self.onProcessing), HistoryOrderData(sectionName: "В ожидании отправки", orders: self.onProcessOfSending), HistoryOrderData(sectionName: "Отправлен", orders: self.sentItem), HistoryOrderData(sectionName: "Получен", orders: self.completed)]
                    self.tableView.reloadData()
                }
            } else {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                noDataLabel.text          = "Надо войти"
                noDataLabel.textColor     = UIColor.gray
                noDataLabel.textAlignment = .center
                self.tableView.backgroundView  = noDataLabel
                self.tableView.separatorStyle  = .none
            }
        }
    }
    
    // MARK: API CALL
    
    func fetchOrders(onCompleted: @escaping () -> ()) {
        
        let ref = DataService.instance.REF_ORDERS
        let currentUserUid = Auth.auth().currentUser?.uid
        
        ref.whereField("isProcessed", isEqualTo: false).whereField("isSent", isEqualTo: false).whereField("isDelivered", isEqualTo: false).whereField("userId", isEqualTo: currentUserUid ?? "").addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.onProcessing = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                let data = ItemData(itemData: document.data())
                self?.onProcessing.append(data)
            }
            
            onCompleted()
            
        }
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: false).whereField("isDelivered", isEqualTo: false).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.onProcessOfSending = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                let data = ItemData(itemData: document.data())
                self?.onProcessOfSending.append(data)
            }
            
            onCompleted()
        }
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: true).whereField("isDelivered", isEqualTo: false).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.sentItem = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                let data = ItemData(itemData: document.data())
                self?.sentItem.append(data)
            }
            
            onCompleted()
        }
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: true).whereField("isDelivered", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.completed = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                let data = ItemData(itemData: document.data())
                self?.completed.append(data)
            }
            
            onCompleted()
        }
        
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return historyOrderArray.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onProcessing.count == 0 && onProcessOfSending.count == 0 && sentItem.count == 0 && completed.count == 0 {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "История покупок пустая"
            noDataLabel.textColor     = UIColor.gray
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            return 0
        }
        let items = historyOrderArray[section].orders
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let items = self.historyOrderArray[indexPath.section].orders
        let itemsName = historyOrderArray[indexPath.section].sectionName
        let item = items[indexPath.row]
        cell.configureCell(data: item)
        if itemsName == "В обработке" {
            cell.statusView.backgroundColor = UIColor.init(red: 255/255, green: 149/255, blue: 0/255, alpha: 100)
        } else if itemsName == "В ожидании отправки" {
            cell.statusView.backgroundColor = UIColor.init(red: 88/255, green: 86/255, blue: 214/255, alpha: 100)
        } else if itemsName == "Отправлен" {
            cell.statusView.backgroundColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 100)
        } else if itemsName == "Получен" {
           cell.statusView.backgroundColor = UIColor.init(red: 76/255, green: 217/255, blue: 100/255, alpha: 100)
        }
        
        return cell
    }
    
    // Title Header in Section
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if historyOrderArray[section].orders.count == 0 {
            return nil
        }
        return historyOrderArray[section].sectionName
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        case 2:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        default:
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        case 2:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        default:
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }

}






