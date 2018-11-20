//
//  TestimonitalViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import Firebase

class TestimonitalViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var testimonials = [TestimonialData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        
        fetchTestimonialData()

    }

    // MARK: API CALL
    func fetchTestimonialData() {
        
        DataService.instance.REF_TESTIMONIALS.whereField("isPublished", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
            self?.testimonials = []
            
            guard let documents = documentSnapshot?.documents else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            for document in documents {
                let data = TestimonialData(dictionary: document.data())
                self?.testimonials.append(data)
            }
            
            self?.collectionView.reloadData()
            
        }
        
    }

}

extension TestimonitalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if testimonials.count == 0 {
            collectionView.setEmptyMessage("Нету отзывов")
        } else {
            collectionView.restore()
        }
        
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonialCell", for: indexPath) as! TestimonialCollectionViewCell
        let testimonial = testimonials[indexPath.row]
        cell.configureCell(testimonials: testimonial)
        return cell
    }
    
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.text = "Отзывы отсуствуют"
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
