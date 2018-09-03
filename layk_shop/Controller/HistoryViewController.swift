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
import Reachability
import NVActivityIndicatorView

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyHistoryOrderView: UIView!
    @IBOutlet var loginNotificationView: UIView!
    
    fileprivate var onProcessing = [ItemData]()
    fileprivate var onProcessOfSending = [ItemData]()
    fileprivate var sentItem = [ItemData]()
    fileprivate var completed = [ItemData]()

    var historyOrderArray = [HistoryOrderData]()
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .ballClipRotateMultiple, color: UIColor.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        authorizationStatusCheck()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check and set status network initially once Tab Bar Controller is shown since App Delegate will not trigger again
        // untill Network will be updated again
        networkStatusDidChange(status: ReachabilityManager.shared.reachabilityStatus)
        
        // Add Network status listener
        ReachabilityManager.shared.addListener(listener: self)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_USER_BADGE_COUNT.document(currentUserUid).setData(["count": 0])
             
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove Network status listener
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    // MARK: API CALL
    
    
    func authorizationStatusCheck() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                
                // Remove background View
                self.tableView.backgroundView = nil
                print("Authronization background view was removed")
                

                self.fetchOrders {
                    self.historyOrderArray = [HistoryOrderData(sectionName: "В обработке", orders: self.onProcessing), HistoryOrderData(sectionName: "В ожидании отправки", orders: self.onProcessOfSending), HistoryOrderData(sectionName: "Отправлен", orders: self.sentItem), HistoryOrderData(sectionName: "Получен", orders: self.completed)]
                    self.tableView.reloadData()
                }
            } else {
                
                self.tableView.backgroundView = self.loginNotificationView
                print("Login Notification View was added")
                // Reset all arrays, reload TableView and set backgroundView
                self.onProcessing.removeAll()
                self.onProcessOfSending.removeAll()
                self.sentItem.removeAll()
                self.completed.removeAll()
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchOrders(onCompleted: @escaping () -> ()) {
        
        let ref = DataService.instance.REF_ORDERS
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        ref.whereField("isProcessed", isEqualTo: false).whereField("isSent", isEqualTo: false).whereField("isDelivered", isEqualTo: false).whereField("userId", isEqualTo: currentUserUid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
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
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: false).whereField("isDelivered", isEqualTo: false).whereField("userId", isEqualTo: currentUserUid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
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
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: true).whereField("isDelivered", isEqualTo: false).whereField("userId", isEqualTo: currentUserUid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
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
        
        ref.whereField("isProcessed", isEqualTo: true).whereField("isSent", isEqualTo: true).whereField("isDelivered", isEqualTo: true).whereField("userId", isEqualTo: currentUserUid).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
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
    
    // MARK: - Helpers
    
    fileprivate func updateNetworkTitleStatus() {
        navigationItem.title = "История"
        navigationItem.titleView = nil
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return historyOrderArray.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onProcessing.count == 0 && onProcessOfSending.count == 0 && sentItem.count == 0 && completed.count == 0 {
            // Check if backgroundView is nil (in this case LoginNotificationView) and if yes only in this case show Empty History Order View
            if tableView.backgroundView == nil {
                tableView.backgroundView = emptyHistoryOrderView
            }
            return 0
        }
        let items = historyOrderArray[section].orders
        tableView.backgroundView = nil
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell
        let items = self.historyOrderArray[indexPath.section].orders
        let sectionName = historyOrderArray[indexPath.section].sectionName
        let item = items[indexPath.row]
        
        cell.configureCell(data: item, sectionName: sectionName)
        

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
        case 3:
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
        case 3:
            if self.tableView(tableView, numberOfRowsInSection: section) <= 0 {
                return CGFloat.leastNonzeroMagnitude
            }
        default:
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }

}

extension HistoryViewController: NetworkStatusListener {
    
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






