//
//  NetworkStatusTitleView.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 8/29/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TitleView: UIView {
    
    var titleLblText: String!
    var titleLblTextColor: UIColor!
    var indicatorColor: UIColor!
    
    init(frame: CGRect, titleLblText: String, titleLblTextColor: UIColor, indicatorColor: UIColor) {
        super.init(frame: frame)
        self.titleLblText = titleLblText
        self.titleLblTextColor = titleLblTextColor
        self.indicatorColor = indicatorColor
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20), type: .ballClipRotateMultiple, color: indicatorColor)
        activityIndicator.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = titleLblText
        titleLabel.textColor = titleLblTextColor
        
        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicator.frame.size.height))
        titleLabel.frame = CGRect(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width + 8,
                                  y: activityIndicator.frame.origin.y,
                                  width: fittingSize.width,
                                  height: fittingSize.height)
        
        let rect = CGRect(x: (activityIndicator.frame.size.width + 8 + titleLabel.frame.size.width) / 2,
                            y: (activityIndicator.frame.size.height) / 2,
                            width: activityIndicator.frame.size.width + 8 + titleLabel.frame.size.width,
                            height: activityIndicator.frame.size.height)
        
        self.frame = rect
        self.addSubview(activityIndicator)
        self.addSubview(titleLabel)
    }
}
