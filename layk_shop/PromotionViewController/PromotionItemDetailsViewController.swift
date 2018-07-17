//
//  PromotionItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/9/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PromotionItemDetailsViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var closeVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var coverViewTop: NSLayoutConstraint!
    
    @IBOutlet var panToClose: InteractionPanToClose!
    @IBOutlet weak var tableView: UITableView!
    
    var listener: ListenerRegistration!
    var historyData: HistorySectionData!
    var historyDataDetails = [HistorySectionDataDetails]()
    
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
        
        fetchHistorySectionDataDetails()
        
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    // MARK: API CALL
    
    func fetchHistorySectionDataDetails() {
        
        listener = DataService.instance.REF_PROMOTION_SECTION_MEDIA.whereField("documentId", isEqualTo: historyData.documentId).addSnapshotListener({ [weak self] (documentSnapshot, error) in
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                if let data = HistorySectionDataDetails(dictionary: document.data()) {
                    self?.historyDataDetails.append(data)
                }
                
            }
            
            self?.attemptToReload()
        })
    }
    
    func attemptToReload() {
        historyDataDetails.sort(by: {$0.timestamp < $1.timestamp})
        tableView.reloadData()
    }

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
            return historyDataDetails.count
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
        let data = historyDataDetails[indexPath.row]
        mediaCell.configureCell(data: data)
        return mediaCell
    }
    
}

extension PromotionItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        coverViewTop.constant = offsetY < 0 ? 0 : max(-offsetY, -300)
    }
    
    
}

