//
//  DeliveryViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/25/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DeliveryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ModalViewControllerDelegate {


    @IBOutlet weak var tableView: UITableView!
    var orderItems = [CartData]()
    var name: String?
    var phone: String?
    var city: String?
    var deliveryAddress: String?
    var comments: String?
    var placeholderLbl: UILabel!
    var sizeCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        navigationItem.title = "Доставка"
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    deinit {
        print("DeliveryViewController has been deinitialized")
    }
    
    // MARK: - TextView Delegate
    
    func addTextViewPlaceholder(textView: UITextView) {
        placeholderLbl = UILabel()
        placeholderLbl.text = "Комментарий к заказу"
        placeholderLbl.font = UIFont.italicSystemFont(ofSize: 17)
        placeholderLbl.sizeToFit()
        textView.addSubview(placeholderLbl)
        placeholderLbl.frame.origin = CGPoint(x: 5, y: 10)
        placeholderLbl.textColor = UIColor.init(red: 202/255, green: 202/255, blue: 207/255, alpha: 100)
        textView.isHidden = !textView.text.isEmpty

    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLbl.isHidden = !textView.text.isEmpty
        
        // Adjust height of the row based on textView height
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        // Copy textView text to 'Comments' variable
        comments = textView.text
        
    }
    
    // MARK: - Error handler
    
    func submitNewOrder(name: String, phone: String, city: String, address: String) throws -> (String, String, String, String) {
        
        guard name.count > 0 else {
            throw NewOrderErrors.invalidName
        }
        guard phone.count > 0 else {
            throw NewOrderErrors.invalidPhone
        }
        guard city.count > 0 else {
            throw NewOrderErrors.invalidCity
        }
        guard address.count > 0 else {
            throw NewOrderErrors.invalidDeliveryAddress
        }
        
        return (name, phone, city, address)
    }
    
    // MARK: - Alerts
    
    func alert(title: String, errMsg: String) {
        let alert = UIAlertController(title: title, message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    // MARK: - TextField Delegate
    
    // Get values from the textFields based on their tags which were assigned in cellForRowAt indexPath
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let kActualText = (textField.text ?? "") + string
        switch textField.tag
        {
        case 0:
            name = kActualText;
        case 1:
            phone = kActualText;
        case 2:
            city = kActualText;
        case 3:
            deliveryAddress = kActualText;
        default:
            print("It is nothing");
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCompletedVC" {
            if let modalVC = segue.destination as? ProcessingViewController {
                modalVC.delegate = self
            }
        }
    }
    
    // MARK: - Modal Delegate
    
    func dismissed() {
        let rootVC = navigationController?.viewControllers.first as? CartViewController
        rootVC?.items.removeAll()
        rootVC?.tableView.reloadData()
        
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3] as! UITabBarItem
            // if array is empty, set badge to nil
            tabItem.badgeValue = nil
        }
        
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    // MARK: - Actions
 
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        do {
            // If type and then delete it allow to process. WRONG!!!
            let (name, phone, city, address) = try submitNewOrder(name: self.name ?? "", phone: self.phone ?? "", city: self.city ?? "", address: self.deliveryAddress ?? "")
            
            let details: [String: Any] = ["name": name, "phone": phone, "city": city, "address": address, "comments": comments ?? ""]
            print(details)
            
            let currentUserUid = Auth.auth().currentUser?.uid
            let timestamp = NSDate().timeIntervalSince1970
            
            // get image name so then fetch it using FirebaseStorageUI
            for item in orderItems {
                let orderDetails: [String : Any] = ["name": item.name ?? "", "size": item.size ?? "", "price": item.price ?? 0, "itemDocumentId": item.documentId ?? "", "ref": item.ref, "count": item.count, "userId": currentUserUid ?? "", "avatarName": item.itemName!, "isProcessed": false, "isDelivered": false, "isSent": false, "timestamp": timestamp]
                let documentId = DataService.instance.REF_ORDERS.document()
                documentId.setData(orderDetails)
                
                // Reference to the item document
                let documentRef = DataService.instance.REF_ITEMS.document(item.documentId ?? "")
                
                // Run transcation
                Firestore.firestore().runTransaction({ [weak self] (transaction, errorPointer) -> Any?  in
                    let document: DocumentSnapshot
                    do {
                        try document = transaction.getDocument(documentRef)
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }

                    // Fetch amount of size of the purchased item
                    if let nestedDictionary = document.data()?["size"] as? [String: Any] {
                        if let sizeCount = nestedDictionary[item.size ?? ""] as? Int {
                            self?.sizeCount = sizeCount
                        }
                    }
                    
                    guard let oldSizeCount = self?.sizeCount else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve size from snapshot \(document)"
                            ]
                        )
                        errorPointer?.pointee = error
                        return nil
                    }
                    
                    // Deduct from the current items count the amount of the bought items
                    transaction.updateData(["size.\(item.size ?? "")": oldSizeCount - item.count], forDocument: documentRef)
                    return nil
                }) { (object, error) in
                    if let error = error {
                        print("Transaction failed: \(error)")
                    } else {
                        print("Transaction successfully committed!")
                    }
                }
                
            }
            
            performSegue(withIdentifier: "toCompletedVC", sender: nil)
            
        } catch {
            let error = error.localizedDescription
            self.alert(title: "Ооооопсс...!", errMsg: error)
        }
    }
}

extension DeliveryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            addTextViewPlaceholder(textView: cell.commentTextView)
            cell.commentTextView.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        switch indexPath.row {
        case 0:
            // Maybe better solution without tag?
            cell.detailsTextField.placeholder = "Ф.И.О"
            cell.detailsTextField.tag = 0
        case 1:
            cell.detailsTextField.placeholder = "Номер телефона"
            cell.detailsTextField.tag = 1
        case 2:
            cell.detailsTextField.placeholder = "Город"
            cell.detailsTextField.tag = 2
        case 3:
            cell.detailsTextField.placeholder = "Отделение Новой Почты"
            cell.detailsTextField.tag = 3
        default:
            break
        }
        cell.detailsTextField.delegate = self
        return cell
        
    }
    
}
