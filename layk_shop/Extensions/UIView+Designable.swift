//
//  UIView+Designable.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/23/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var viewBorderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
