//
//  ItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import SDWebImage
import ImageViewer

protocol ItemDetailsViewControllerDelegate: class {
    func cartButton(status: Bool)
}

extension UIImageView: DisplaceableView {}

struct DataItem {
    let imageView: UIImageView
    let galleryItem: GalleryItem
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
    
    var items: [DataItem] = []
    
    var galleryItem: GalleryItem!
    
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
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            
            // Add tap gesture
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleZoomIn(sender:)))
            tapRecognizer.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(tapRecognizer)
            
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setIndicatorStyle(.gray)
            
            
            // First load image and only then get the image to ImageViewer
            
            imageView.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .continueInBackground) { (image, error, cacheType, url) in
                if image != nil {
                    // Get image from ImageView for ImageViewer
                    let image = image
                    self.galleryItem = GalleryItem.image { $0(image) }
                    self.items.append(DataItem(imageView: imageView, galleryItem: self.galleryItem))
                }
            }
            
            count += 1
            contentWidth = pageScrollView.frame.midX + view.frame.size.width * CGFloat(count)
            pageScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageView.frame = CGRect(x: contentWidth - 150, y: (pageScrollView.frame.size.height / 2) - 150, width: 300, height: 300)

        }
        
        pageScrollView.contentSize = CGSize(width: contentWidth + pageScrollView.frame.midX, height: pageScrollView.frame.size.height)
    }
    
    @objc fileprivate func handleZoomIn(sender: UIGestureRecognizer) {
        guard let displacedView = sender.view as? UIImageView else { return }
        guard let displacedViewIndex = items.firstIndex(where: { $0.imageView == displacedView }) else { return }
        let galleryViewController = GalleryViewController(startIndex: displacedViewIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
        self.presentImageGallery(galleryViewController)
    }
    
    // Setup ImageViewer UI
    
    func galleryConfiguration() -> GalleryConfiguration {
        return [
            // Remove delete button
            GalleryConfigurationItem.deleteButtonMode(.none),
            // Remove See All button
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            // Change background color
            GalleryConfigurationItem.overlayColor(UIColor.init(red: 43/255, green: 42/255, blue: 41/255, alpha: 100))
        ]
    }
    

    fileprivate func setupUserInterface() {
        //Set UI
        nameLbl.text = itemDetails.name
        priceLbl.text = "\(itemDetails.price) грн"
        
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
                    button.layer.borderColor = UIColor.clear.cgColor
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
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 1
        button.layer.borderColor = buttonColor.cgColor
    }
    
    
    // MARK: - Actions
    
    @IBAction func sizeBtnTapped(_ sender: UIButton) {
        buttons.forEach { (element) in
            if element.tag == sender.tag {
                sender.backgroundColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100)
                sender.setTitleColor(UIColor.white, for: .normal)
                sender.layer.borderColor = UIColor.clear.cgColor
            } else {
                if element.isEnabled == true {
                    element.backgroundColor = UIColor.white
                    element.setTitleColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 100), for: .normal)
                    element.layer.borderColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 100).cgColor
                }
            }
        }
    }

}

extension ItemDetailsViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        
        return index < items.count ? items[index].imageView : nil
    }
}

extension ItemDetailsViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
    
        return items[index].galleryItem
    }
}

extension ItemDetailsViewController: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
        
        let imageView = items[index].imageView
        imageView.removeFromSuperview()
        items.remove(at: index)
    }
}

extension ItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
    
}
