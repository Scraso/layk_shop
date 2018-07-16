//
//  PresentSectionViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/9/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

class PresentSectionViewController: NSObject, UIViewControllerAnimatedTransitioning {

    var cellFrame: CGRect!
    var cellTransform: CATransform3D!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let destination = transitionContext.viewController(forKey: .to) as! PromotionItemDetailsViewController
        let containerView = transitionContext.containerView
        
        containerView.addSubview(destination.view)
        
        // Initial state
        
        let widthConstraint = destination.scrollView.widthAnchor.constraint(equalToConstant: 300)
        let heightConstraint = destination.scrollView.heightAnchor.constraint(equalToConstant: 240)
        let bottomConstraint = destination.scrollView.bottomAnchor.constraint(equalTo: destination.coverView.bottomAnchor)
        
        NSLayoutConstraint.activate([widthConstraint,heightConstraint,bottomConstraint])
        
        let translate = CATransform3DMakeTranslation(cellFrame.origin.x, cellFrame.origin.y, 0.0)
        let transform = CATransform3DConcat(translate, cellTransform)
        
        destination.view.layer.transform = transform
        destination.view.layer.zPosition = 999
        
        containerView.layoutIfNeeded()
        
        destination.scrollView.layer.cornerRadius = 14
        destination.scrollView.layer.shadowOpacity = 0.25
        destination.scrollView.layer.shadowOffset.height = 10
        destination.scrollView.layer.shadowRadius = 20
        
        let moveUpTransform = CGAffineTransform(translationX: 0, y: -100)
        let scaleUpTranform = CGAffineTransform(scaleX: 2, y: 2)
        let removeFromViewTransform = moveUpTransform.concatenating(scaleUpTranform)
        
        destination.closeVisualEffectView.alpha = 0
        destination.closeVisualEffectView.transform = removeFromViewTransform
        
        
        let animator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 0.7) {
            
            // Final state
            
            NSLayoutConstraint.deactivate([widthConstraint,heightConstraint,bottomConstraint])
            destination.view.layer.transform = CATransform3DIdentity
            containerView.layoutIfNeeded()
            
            destination.closeVisualEffectView.alpha = 1
            destination.closeVisualEffectView.transform = .identity
            
            destination.scrollView.layer.cornerRadius = 0
            
        }
        
        animator.addCompletion { (finished) in
            
            // Completion
            
            transitionContext.completeTransition(true)
            
        }
        
        animator.startAnimation()
        
        
    }
}
