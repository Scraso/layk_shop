//
//  PromotionItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/9/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PromotionItemDetailsViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var closeVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var coverViewTop: NSLayoutConstraint!
    

    @IBOutlet var panToClose: InteractionPanToClose!
    @IBOutlet weak var tableView: UITableView!
    
    var historyData: HistorySectionData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        scrollView.contentSize = .zero
        
        // Set header image
        coverImageView.sd_setShowActivityIndicatorView(true)
        coverImageView.sd_setIndicatorStyle(.gray)
        coverImageView.sd_setImage(with: URL(string: historyData.avatarImageUrl))
        
    }
    
    override var prefersStatusBarHidden: Bool { return true }

}

extension PromotionItemDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let bodyCell = tableView.dequeueReusableCell(withIdentifier: "Body", for: indexPath) as! PromotionItemDetailsBodyTableViewCell
            bodyCell.textView.text = historyData.bodyText
            return bodyCell
        }
        let mediaCell = tableView.dequeueReusableCell(withIdentifier: "Media", for: indexPath) as! PromotionItemDetailsMediaTableViewCell
        mediaCell.titleLbl.text = historyData.title
        mediaCell.bodyLbl.text = historyData.content
        let placeholderImage = #imageLiteral(resourceName: "promotion_placeholder")
        mediaCell.mediaImageView.sd_setShowActivityIndicatorView(true)
        mediaCell.mediaImageView.sd_setIndicatorStyle(.gray)
        mediaCell.mediaImageView.sd_setImage(with: URL(string: historyData.imageUrl), placeholderImage: placeholderImage)
        return mediaCell
    }
    
}

extension PromotionItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        coverViewTop.constant = offsetY < 0 ? 0 : max(-offsetY, -300)
    }
    
    
}

