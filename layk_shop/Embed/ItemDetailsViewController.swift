//
//  ItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
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
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var detailLables: [UILabel]!
    
    fileprivate var contentWidth: CGFloat = 0.0
    fileprivate var count = -1
    var itemDetails: ItemListData!
    
    weak var delegate: ItemDetailsViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageScrollView.delegate = self
        pageController()
        setupUserInterface()
        pageControl.numberOfPages = itemDetails.imageURLs.count
        
    }
    
    // MARK: UI Setup
    
    fileprivate func pageController() {
        for url in itemDetails.imageURLs {
            let placeholder = #imageLiteral(resourceName: "promotion_placeholder")
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            
            // Add tap gesture
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomIn(sender:)))
            tapRecognizer.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(tapRecognizer)
            
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            imageView.sd_setImage(with: URL(string: url), placeholderImage: placeholder)
            count += 1
            contentWidth = pageScrollView.frame.midX + view.frame.size.width * CGFloat(count)
            pageScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.frame = CGRect(x: contentWidth - 150, y: (pageScrollView.frame.size.height / 2) - 150, width: 300, height: 300)
        }
        
        pageScrollView.contentSize = CGSize(width: contentWidth + pageScrollView.frame.midX, height: pageScrollView.frame.size.height)
    }
    
    fileprivate var startingFrame: CGRect?
    fileprivate var backgroundView: UIView?
    fileprivate var startingImageView: UIImageView?
    fileprivate var zoomingImageView: UIImageView?
    
    @objc fileprivate func handleZoomIn(sender: UIGestureRecognizer) {
        startingImageView = sender.view as? UIImageView
        startingImageView?.isHidden = true
        startingFrame = startingImageView?.superview?.convert(startingImageView!.frame, to: nil)
        
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView?.image = startingImageView?.image
        zoomingImageView?.isUserInteractionEnabled = true
        
        // Add tap gesture to Zoom Out
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(sender:)))
        tapRecognizer.numberOfTapsRequired = 1
        zoomingImageView?.addGestureRecognizer(tapRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchZoom(sender:)))
        zoomingImageView?.addGestureRecognizer(pinchRecognizer)

    
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(zoomingImageView!)
            // Change background color
            backgroundView = UIView(frame: keyWindow.frame)
            backgroundView?.backgroundColor = UIColor.init(red: 31/255, green: 41/255, blue: 50/255, alpha: 100)
            backgroundView?.alpha = 0
            keyWindow.addSubview(backgroundView!)
            keyWindow.addSubview(zoomingImageView!)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.backgroundView?.alpha = 1
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                self.zoomingImageView?.center = keyWindow.center
                
            }, completion: nil)

        }
        
    }
    
    // Zoom out
    @objc fileprivate func handleZoomOut(sender: UIGestureRecognizer) {
        if let zoomOutImageView = sender.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.backgroundView?.alpha = 0
            }) { (comleted: Bool) in
                // remove from SuperView
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
    }
    
    // Pinch Zoom
    @objc fileprivate func pinchZoom(sender: UIPinchGestureRecognizer) {
        if let imageView = sender.view {
            imageView.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
            sender.scale = 1.0
            
            switch sender.state {
            case .ended:
                if imageView.frame.maxX > (zoomingImageView?.frame.maxX)! {
                    imageView.frame = (zoomingImageView?.frame)!
                }
            default:
                break
            }

        }

    }
    
    fileprivate func setupUserInterface() {
        //Set UI
        nameLbl.text = itemDetails.name
        priceLbl.text = "\(itemDetails.price ?? 0) грн"
        
        firstDetailLbl.text = itemDetails.itemDetails[exist: 0]
        secondDetailLbl.text = itemDetails.itemDetails[exist: 1]
        thirdDetailLbl.text = itemDetails.itemDetails[exist: 2]
        
        // Get the item with the maxium count and set it as a default one.
        let maxValue = itemDetails.itemSizes.max { (a, b) -> Bool in
            return a.value < b.value
        }
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
        
        // Check which size is available
        for button in buttons {
            for (key, value) in itemDetails.itemSizes {
                if button.currentTitle == key {
                    if value > 0 {
                        buttonStatus(button: button, isEnabled: true)
                    } else {
                        buttonStatus(button: button, isEnabled: false)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper
    
    fileprivate func buttonStatus(button: UIButton, isEnabled: Bool) {
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
