//
//  OneLinePixel.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/23/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class OneLinePixel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    override func updateConstraints() {
        let height = (1.0 / UIScreen.main.scale)
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height))
        
        super.updateConstraints()
    }
    
}
