//
//  UITableView+indexPathForView.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/14/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit


public extension UITableView {
    
    /**
     This method returns the indexPath of the cell that contains the specified view
     
     - Parameter view: The view to find.
     
     - Returns: The indexPath of the cell containing the view, or nil if it can't be found
     
     */
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}
