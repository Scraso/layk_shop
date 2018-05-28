//
//  TestimonitalViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/20/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class TestimonitalViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
    }

}

extension TestimonitalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testimonials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestimonialCell", for: indexPath) as! TestimonialCollectionViewCell
        let testimonial = testimonials[indexPath.row]
        cell.testimonialLbl.text = testimonial["text"]
        cell.nameLbl.text = testimonial["name"]
        cell.avatarImageView.image = UIImage(named: testimonial["avatar"]!)
        return cell
    }
    
}
