//
//  PromotionViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/19/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI
import SDWebImage

class PromotionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listener: ListenerRegistration!
    var imageNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchImages()

    }
    
    deinit {
        listener.remove()
        print("PromotionViewController has been deinitialized")
    }
    
    // MARK: - API CALL
    
    func fetchImages() {
        listener = DataService.instance.REF_PROMOTION_SECTION.whereField("isPublished", isEqualTo: true).addSnapshotListener({ [weak self] (documentSnapshot, error) in
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            let imageURLs = documents.map { $0["imageURL"]! }
            for imageURL in imageURLs {
                if let editedURL = (imageURL as! String).slice(from: "promotion-images/", to: ".jpg") {
                    self?.imageNames.append(editedURL)
                }
            }

            self?.collectionView.reloadData()
        
        })
    }
    
}

extension PromotionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as! PromotionCollectionViewCell

        let imageName = imageNames[indexPath.row]
        let ref = DataService.instance.REF_PROMOTION_IMAGES.child("\(imageName).jpg")
        let imageView = cell.backgroundImageView
        let placeholderImage = #imageLiteral(resourceName: "promotion_placeholder")
        imageView?.sd_setShowActivityIndicatorView(true)
        imageView?.sd_setIndicatorStyle(.gray)
        imageView?.sd_setImage(with: ref, placeholderImage: placeholderImage)
        return cell
    }
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
