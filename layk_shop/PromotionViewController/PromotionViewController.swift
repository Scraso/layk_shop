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
import SDWebImage

protocol PromotionCollectionDelegate: class {
    func didTap(cell: PromotionCollectionViewCell, on collectionView: UICollectionView, with transform: CATransform3D, for historySection: HistorySectionData)
}

class PromotionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: PromotionCollectionDelegate?
    
    var listener: ListenerRegistration!
    
    var historySectionData = [HistorySectionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchPromotionData()

    }
    
    deinit {
        listener.remove()
        print("PromotionViewController has been deinitialized")
    }
    
    // MARK: - API CALL
    
    func fetchPromotionData() {
        
        let ref = DataService.instance.REF_PROMOTION_SECTION
        
        ref.whereField("isPublished", isEqualTo: true).addSnapshotListener { [weak self ](documentSnapshot, error) in
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                if let data = HistorySectionData(dictionary: document.data(), documentId: document.documentID) {
                    self?.historySectionData.append(data)
                }
            }
            self?.collectionView.reloadData()
            
        }
        
    }
    
    
    
//    func fetchPromotionData() {
//
//        let ref = DataService.instance.REF_PROMOTION_SECTION
//
//        ref.whereField("isPublished", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
//            guard let documents = documentSnapshot?.documents else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//
//            for document in documents {
//                let documentData = document.data()
//                let avatarImageUrl = documentData["avatarImageUrl"] as? String ?? ""
//                let bodyText = documentData["body_text"] as? String ?? ""
//                self?.fetchPromotionDataDetails(documentId: document.documentID, avatarImageUrl: avatarImageUrl, bodyText: bodyText)
//            }
//        }
//
//    }
//
//    func fetchPromotionDataDetails(documentId: String, avatarImageUrl: String, bodyText: String) {
//        // check for document based on the document ID to make sure that fetched data belongs to the selected item
//        let ref = DataService.instance.REF_PROMOTION_SECTION.document(documentId).collection("history_details").whereField("id", isEqualTo: documentId)
//
//        ref.addSnapshotListener { [weak self] (documentSnapshot, error) in
//
//            guard let documents = documentSnapshot?.documents else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//
//            for document in documents {
//                if let documentData = HistorySectionData(dictionary: document.data(), avatarImageUrl: avatarImageUrl, bodyText: bodyText, documentId: documentId) {
//
//                    // Check if same item is already in array
//                    if !(self?.historySectionData.contains(documentData))! {
//                        self?.historySectionData.append(documentData)
//                    }
//
//                }
//            }
//
//            self?.collectionView.reloadData()
//
//        }
//    }

    func animateCell(cellFrame: CGRect) -> CATransform3D {
        let angleFromX = Double((-cellFrame.origin.x) / 10)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(CATransform3DIdentity, scaleFromX, scaleFromX, 1)
        
        return CATransform3DConcat(rotation, scale)
    }

}

extension PromotionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historySectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as! PromotionCollectionViewCell
        let sectionData = historySectionData[indexPath.row]
        cell.configureCell(data: sectionData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PromotionCollectionViewCell
        let sectionData = historySectionData[indexPath.row]
        let transform = animateCell(cellFrame: cell.frame)
        delegate?.didTap(cell: cell, on: collectionView, with: transform, for: sectionData)
        
    }
    
}