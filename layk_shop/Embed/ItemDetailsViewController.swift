//
//  ItemDetailsViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageScrollView: UIScrollView!

    var contentWidth: CGFloat = 0.0
    var images = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageScrollView.delegate = self
        
        for x in 0...2 {
            let image = UIImage(named: "leggins_detail_\(x)")
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            contentWidth = pageScrollView.frame.midX + view.frame.size.width * CGFloat(x)
            
            pageScrollView.addSubview(imageView)
            
            imageView.frame = CGRect(x: contentWidth - 150, y: (pageScrollView.frame.size.height / 2) - 150, width: 300, height: 300)
            
        }
        
        pageScrollView.contentSize = CGSize(width: contentWidth + pageScrollView.frame.midX, height: pageScrollView.frame.size.height)
        
    }
    
}

extension ItemDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
}


