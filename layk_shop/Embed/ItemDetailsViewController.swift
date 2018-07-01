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

protocol ItemDetailsViewControllerDelegate: class {
    func cartButton(status: Bool)
}

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
    var itemDetails: ItemListData!
    var itemImageView: UIImage?
    
    weak var delegate: ItemDetailsViewControllerDelegate? = nil
    
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
                } else {
                    if delegate != nil {
                        delegate?.cartButton(status: false)
                    }
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

}

extension ItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
}


