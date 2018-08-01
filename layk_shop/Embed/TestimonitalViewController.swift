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
    fileprivate func fetchTestimonialData() {
        
        DataService.instance.REF_TESTIMONIALS.whereField("isPublished", isEqualTo: true).addSnapshotListener { [weak self] (documentSnapshot, error) in
            
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
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonialCell", for: indexPath) as! TestimonialCollectionViewCell
        let testimonial = testimonials[indexPath.row]
        cell.configureCell(testimonials: testimonial)
        return cell
    }
    
}
