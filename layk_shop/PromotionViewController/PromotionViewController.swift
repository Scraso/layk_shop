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
    
    fileprivate var listener: ListenerRegistration!
    
    fileprivate var historySectionData = [HistorySectionData]()
    
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
        
        let ref = DataService.instance.REF_NEWS_SECTION_HEADER
        
        ref.whereField("isPublished", isEqualTo: true).addSnapshotListener { [weak self ](documentSnapshot, error) in
            
            self?.historySectionData = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                if let data = HistorySectionData(dictionary: document.data(), documentId: document.documentID) {
                    self?.historySectionData.append(data)
                }
            }
            self?.attemptToReload()
            
        }
        
    }
    
    func attemptToReload() {
        historySectionData.sort(by: {$0.timestamp > $1.timestamp})
        collectionView.reloadData()
    }



}

extension PromotionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historySectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCell", for: indexPath) as! PromotionCollectionViewCell
        let sectionData = historySectionData[indexPath.row]
        cell.layer.transform = animateCell(cellFrame: cell.frame)
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

extension PromotionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [PromotionCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                
                let translationX = cellFrame.origin.x / 5
                cell.backgroundImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                
                cell.layer.transform = animateCell(cellFrame: cellFrame)
                
            }
        }
    }
    
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

