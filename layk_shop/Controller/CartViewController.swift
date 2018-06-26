//
//  CartViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/25/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableViewBottomToNextBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomToViewBottomConstraint: NSLayoutConstraint!
    
    var items = [CartData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDelivery" {
            let destination = segue.destination as? DeliveryViewController
            destination?.orderItems = items
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toDelivery", sender: self)
    }

}

extension CartViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if items.count == 0 {
                tableViewBottomToNextBtnTopConstraint.priority = UILayoutPriority.defaultLow
                tableViewBottomToViewBottomConstraint.priority = UILayoutPriority.defaultHigh

                // Add label wich says there is no items in the cart
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Корзина пустая"
                noDataLabel.textColor = UIColor.darkGray
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
                nextBtn.isHidden = true
                return 0
            }
            tableViewBottomToNextBtnTopConstraint.priority = UILayoutPriority.defaultHigh
            tableViewBottomToViewBottomConstraint.priority = UILayoutPriority.defaultLow
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return items.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemsCell
            let item = items[indexPath.row]
            itemCell.nameLbl.text = "\(item.name ?? "") (\(item.size ?? ""))"
            itemCell.priceLbl.text = "\(item.price ?? 0) грн"
            itemCell.refLbl.text = "Код товара: \(item.ref)"
            itemCell.itemImageView.image = item.itemImageView
            itemCell.countLbl.text = String(item.count)
            itemCell.onButtonTapped = { [weak self] (button: UIButton) in
                if let indexPath = self?.tableView.indexPathForView(button) {
                    self?.items.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    // Set badgeValue to the cart depends on the item in the array
                    if let tabItems = self?.tabBarController?.tabBar.items as NSArray?
                    {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[3] as! UITabBarItem
                        // if array is empty, set badge to nil
                        tabItem.badgeValue = (self?.items.count)! > 0 ? String((self?.items.count)!) : nil
                    }
                    self?.tableView.reloadData()
                }
            }
            return itemCell
        }
        if tableView.numberOfRows(inSection: 0) > 0 {
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalCell
            
            let cost = items.reduce(0, { (result, cartData) -> Int in
                var priceValue = 0
                priceValue += cartData.price ?? 0
                return result + priceValue
                
            })
            totalCell.amountLbl.text = String("\(cost) грн")
            nextBtn.isHidden = false
            return totalCell
        }
        return UITableViewCell()
    }
    
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if items.count == 0 {
                cell.isHidden = true
            }
        }
    }
    
    
    
    
}

