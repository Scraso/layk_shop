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
import Reachability
import NVActivityIndicatorView

protocol DeliveryViewControllerDelegate: class {
    func textField(details: [String: Any])
    func textView(details: String)
}

class DeliveryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: DeliveryViewControllerDelegate? = nil
    
    var orderItems = [CartData]()
    
    // Declared to pass contact details when force and back from Contact View Controller
    var textViewDetails: String?
    
    fileprivate var placeholderLbl: UILabel!
    fileprivate var sizeCount: Int?
    
    var contactDetails = [String: Any]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check and set status network initially once Tab Bar Controller is shown since App Delegate will not trigger again
        // untill Network will be updated again
        networkStatusDidChange(status: ReachabilityManager.shared.reachabilityStatus)
        
        // Add Network status listener
        ReachabilityManager.shared.addListener(listener: self)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            if delegate != nil {
                delegate?.textField(details: contactDetails)
                delegate?.textView(details: textViewDetails ?? "")
            }
        }
    }
    
    deinit {
        print("DeliveryViewController has been deinitialized")
    }
    
    
    // MARK: - TextView Delegate
    
    fileprivate func addTextViewPlaceholder(textView: UITextView) {
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
        // Copy textView text to 'textViewDetails' variable
        textViewDetails = textView.text
        
    }
    
    // MARK: - Error handler
    
    fileprivate func submitNewOrder(dict: [String: Any]) throws -> [String: Any] {
        
        guard dict.keys.contains("name") == true else {
            throw NewOrderErrors.invalidName
        }
        guard dict.keys.contains("city") == true else {
            throw NewOrderErrors.invalidCity
        }
        guard dict.keys.contains("phone") == true else {
            throw NewOrderErrors.invalidPhone
        }
        guard dict.keys.contains("address") == true else {
            throw NewOrderErrors.invalidDeliveryAddress
        }
        
        return dict
    }
    
    // MARK: - Alerts
    
    fileprivate func alert(title: String, errMsg: String) {
        let alert = UIAlertController(title: title, message: errMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    // MARK: - TextField Delegate
    
    // Get values from the textFields based on their tags which were assigned in cellForRowAt indexPath
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let kActualText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField.tag
        {
        case 0:
            contactDetails["name"] = kActualText;
            // Delete key in case field is empty so error handler can check for key is nil
            if kActualText == "" {
                contactDetails.removeValue(forKey: "name")
            }
        case 1:
            contactDetails["phone"] = kActualText;
            if kActualText == "" {
                contactDetails.removeValue(forKey: "phone")
            }
        case 2:
            contactDetails["city"] = kActualText;
            if kActualText == "" {
                contactDetails.removeValue(forKey: "city")
            }
        case 3:
            contactDetails["address"] = kActualText;
            if kActualText == "" {
                contactDetails.removeValue(forKey: "address")
            }
        default:
            print("It is nothing");
        }
        return true
    }
    
    // MARK: - Helpers
    
    fileprivate func showActivityIndicator() {
        let titleView = TitleView(frame: CGRect.zero, titleLblText: "Ожидание сети", titleLblTextColor: .black, indicatorColor: .gray)
        navigationItem.titleView = titleView
        
    }
    
    
    // MARK: - Actions
 
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        
        do {
            let (contactDict) = try submitNewOrder(dict: contactDetails)
            
            var orderDeliveryDetails: [String: Any] = contactDict
            orderDeliveryDetails["comments"] = textViewDetails
            
            let currentUserUid = Auth.auth().currentUser?.uid
            let timestamp = NSDate().timeIntervalSince1970
            
            // get image name so then fetch it using FirebaseStorageUI
            for item in orderItems {
                let orderDetails: [String : Any] = ["name": item.name ?? "", "size": item.size ?? "", "price": item.price ?? 0, "itemDocumentId": item.documentId ?? "", "ref": item.ref, "count": item.count, "userId": currentUserUid ?? "", "avatarImageUrl": item.avatarImageUrl ?? "", "isProcessed": false, "isDelivered": false, "isSent": false, "timestamp": timestamp]
                let documentId = DataService.instance.REF_ORDERS.document()
                documentId.setData(orderDetails)
                
                // Get order document ID and pass to the order details
                orderDeliveryDetails["orderId"] = documentId.documentID
                DataService.instance.REF_ORDER_DELIVERY_DETAILS.addDocument(data: orderDeliveryDetails)
                
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
            cell.commentTextView.text = textViewDetails
            placeholderLbl.isHidden = !cell.commentTextView.text.isEmpty
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        cell.details = contactDetails
        switch indexPath.row {
        case 0:
            cell.detailsTextField.placeholder = "Ф.И.О"
            cell.detailsTextField.tag = 0
            cell.detailsTextField.becomeFirstResponder()
        case 1:
            cell.detailsTextField.placeholder = "Номер телефона"
            cell.detailsTextField.tag = 1
            cell.detailsTextField.keyboardType = .phonePad
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

extension DeliveryViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        
        switch status {
        case .wifi:
            navigationItem.titleView = nil
            print("Reachable via WiFi")
        case .cellular:
            navigationItem.titleView = nil
            print("Reachable via Cellular")
        case .none:
            showActivityIndicator()
            print("Network not reachable")
        }
    }
}
