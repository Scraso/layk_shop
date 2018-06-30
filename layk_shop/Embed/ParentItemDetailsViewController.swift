//
//  ParentItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/26/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ParentItemDetailsViewController: UIViewController {
    
    weak var containerViewController: ItemDetailsViewController?
    var itemDetails: ItemListData!
    var itemImageView: UIImage?
    var selectedBtnSize: String?
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedVC" {
            if let destination = segue.destination as? ItemDetailsViewController {
                self.containerViewController = destination
                destination.itemDetails = itemDetails
                destination.itemImageView = itemImageView
            }
        }
    }
    
    // MARK: - Helpers
    
    // Random character
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1).uppercased as String
        }
        
        return randomString
    }
    

    @IBAction func addToCartBtnTapped(_ sender: UIButton) {
        
        // Index of Cart Controller in Tab Bar
        let navController = self.tabBarController?.viewControllers![3] as! UINavigationController
        // Index of View Controller in Cart Tab
        let cartViewController = navController.viewControllers[0] as! CartViewController
        
        // get the current title of the selected button size based on the background color
        for button in (containerViewController?.buttons)! {
            if button.backgroundColor == UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100) {
                selectedBtnSize = button.currentTitle ?? ""
            }
        }
        
        // Pass document ID in order to update the amount of items left.
        let item = CartData(price: itemDetails.price, name: itemDetails.name ?? "", ref: "\(randomString(length: 3))\(Int(arc4random_uniform(999)))", size: selectedBtnSize, count: 1, documentId: itemDetails.documentId ?? "", itemImageView: itemImageView, itemName: itemDetails.imageName)

        // Check if there is already the same item in array
        let isUniqueItem = cartViewController.items.contains(where: {$0.itemName == item.itemName && $0.size == item.size } )
        
        // If item is already there then update count + 1 if not then add new item in the array
        if isUniqueItem {
            cartViewController.items = cartViewController.items.map {
                var mutableItem = $0
                if $0.itemName == item.itemName && $0.size == item.size {
                    mutableItem.count += 1
                }
                return mutableItem
            }
        } else {
            cartViewController.items.append(item)
        }
        

        // Animate popup notification
        UIView.animate(withDuration: 0.5) {
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform(translationX: 0, y: 40)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.popupView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.popupView.alpha = 0
                })
            })
        }
        
        // Reload tableView only in case CartViewController is loaded, otherwise the app crash.
        // Set TableView reload in ViewDidLoad of Cart View Controller to reload tableView for the first time so then this method will trigger
        // once the new item will be added
        if cartViewController.isViewLoaded == true {
            cartViewController.tableView.reloadData()
        }
        
        // Set badgeValue to the cart depends on the items count
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3] as! UITabBarItem
            
            let count = cartViewController.items.reduce(0) { (result, cartData) -> Int in
                return result + cartData.count
            }
            
            tabItem.badgeValue = String(count)
        }
    }
}
