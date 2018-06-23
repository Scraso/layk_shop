//
//  ItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseStorageUI
import SDWebImage

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageScrollView: UIScrollView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var firstDetailLbl: UILabel!
    @IBOutlet weak var secondDetailLbl: UILabel!
    @IBOutlet weak var thirdDetailLbl: UILabel!
    @IBOutlet weak var xsBtn: UIButton!
    @IBOutlet weak var sBtn: UIButton!
    @IBOutlet weak var mBtn: UIButton!
    @IBOutlet weak var lBtn: UIButton!
    @IBOutlet weak var xlBtn: UIButton!
    
    @IBOutlet var buttons: [UIButton]!
    
    var contentWidth: CGFloat = 0.0
    var count = -1
    var selectedBtnSize: String?
    var itemDetails: ItemListData!
    var cartData = [CartData]()
    var itemImageView: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageScrollView.delegate = self
        pageController()
        setupUserInterface()
        

    }
    
    // MARK: UI Setup
    
    func pageController() {
        for url in itemDetails.imageURLs {
            let editedURL = url.slice(from: "pageControl-images/", to: ".jpg")
            let ref = DataService.instance.REF_PAGECONTROL_IMAGES.child("\(editedURL ?? "").jpg")
            let placeholder = #imageLiteral(resourceName: "promotion_placeholder")
            let imageView = UIImageView()
            imageView.sd_setImage(with: ref, placeholderImage: placeholder)
            count += 1
            contentWidth = pageScrollView.frame.midX + view.frame.size.width * CGFloat(count)
            pageScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.frame = CGRect(x: contentWidth - 150, y: (pageScrollView.frame.size.height / 2) - 150, width: 300, height: 300)
        }
        
        pageScrollView.contentSize = CGSize(width: contentWidth + pageScrollView.frame.midX, height: pageScrollView.frame.size.height)
    }
    
    func setupUserInterface() {
        //Set UI
        nameLbl.text = itemDetails.name
        priceLbl.text = "\(itemDetails.price ?? 0) грн"
        // Possible crash !!!!!
        firstDetailLbl.text = itemDetails.itemDetails[0]
        secondDetailLbl.text = itemDetails.itemDetails[1]
        thirdDetailLbl.text = itemDetails.itemDetails[2]
        
        
        let sizeArray = ["XS" : itemDetails.xsSize ?? 0, "S" : itemDetails.sSize ?? 0, "M" : itemDetails.mSize ?? 0, "L" : itemDetails.lSize ?? 0, "XL" : itemDetails.xlSize ?? 0]
        
        // Get the size which has the most value and make it checked by default
        let maxValue = sizeArray.max(by: { (a, b) -> Bool in
            return a.value < b.value
        })
        for button in buttons {
            if button.currentTitle == maxValue?.key {
                if button.isEnabled == true && (maxValue?.value)! > 0 {
                    button.backgroundColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.borderColor = UIColor.clear
                }
            }
        }
    
        if let xsSize = itemDetails.xsSize {
            if xsSize > 0 {
                buttonStatus(button: xsBtn, isEnabled: true)
            } else {
                buttonStatus(button: xsBtn, isEnabled: false)
            }
        }
        if let sSize = itemDetails.sSize {
            if sSize > 0 {
                buttonStatus(button: sBtn, isEnabled: true)
            } else {
                buttonStatus(button: sBtn, isEnabled: false)
            }
        }
        if let mSize = itemDetails.mSize {
            if mSize > 0 {
                buttonStatus(button: mBtn, isEnabled: true)
            } else {
                buttonStatus(button: mBtn, isEnabled: false)
            }
        }
        if let lSize = itemDetails.lSize {
            if lSize > 0 {
                buttonStatus(button: lBtn, isEnabled: true)
            } else {
                buttonStatus(button: lBtn, isEnabled: false)
            }
        }
        if let xlSize = itemDetails.xlSize {
            if xlSize > 0 {
                buttonStatus(button: xlBtn, isEnabled: true)
            } else {
                buttonStatus(button: xlBtn, isEnabled: false)
            }
        }
    }
    
    // MARK: - Helper
    
    func buttonStatus(button: UIButton, isEnabled: Bool) {
        button.isEnabled = isEnabled
        let enableColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100)
        let disableColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 100)
        let buttonColor = button.isEnabled ? enableColor : disableColor
        button.titleLabel?.textColor = buttonColor
        button.cornerRadius = 22
        button.borderWidth = 1
        button.borderColor = buttonColor
    }
    
    
    // MARK: - Actions
    
    @IBAction func sizeBtnTapped(_ sender: UIButton) {
        buttons.forEach { (element) in
            if element.tag == sender.tag {
                sender.backgroundColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100)
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.borderColor = UIColor.clear
            } else {
                if element.isEnabled == true {
                    element.backgroundColor = UIColor.white
                    element.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 100), for: .normal)
                    element.borderColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100)
                }
            }
        }
        
    }
    
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

    @IBAction func cartBtnTapped(_ sender: UIButton) {
        
        // Index of Cart Controller in Tab Bar
        let navController = self.tabBarController?.viewControllers![3] as! UINavigationController
        // Index of View Controller in Cart Tab
        let cartViewController = navController.viewControllers[0] as! CartViewController
        
        // get the current title of the selected button size based on the background color
        for button in buttons {
            if button.backgroundColor == UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100) {
                selectedBtnSize = button.currentTitle ?? ""
            }
        }
        
        // Pass document ID in order to update the amount of items left. Move size after item name and add Delete item button.
        let item = CartData(price: 1150, name: nameLbl.text ?? "", ref: "\(randomString(length: 3))\(Int(arc4random_uniform(999)))", size: selectedBtnSize, count: 1, documentId: itemDetails.documentId ?? "", itemImageView: itemImageView, itemName: itemDetails.imageName)
    
        cartViewController.items.append(item)
        
        // Reload tableView only in case CartViewController is loaded, otherwise the app crash.
        // Set TableView reload in ViewDidLoad of Cart View Controller to reload tableView for the first time so then this method will trigger
        // once the new item will be added
        if cartViewController.isViewLoaded == true {
            cartViewController.tableView.reloadData()
        }
        
        // Set badgeValue to the cart depends on the item in the array
        if let tabItems = self.tabBarController?.tabBar.items as NSArray?
        {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3] as! UITabBarItem
            tabItem.badgeValue = String(cartViewController.items.count)
        }

    }
    
}

extension ItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
}


