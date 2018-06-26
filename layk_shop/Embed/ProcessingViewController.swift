//
//  ProcessingViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/18/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func dismissed()
}

class ProcessingViewController: UIViewController {
    
    var delegate: ModalViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.dismissed()

    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.dismissed()
            self.dismiss(animated: false, completion: nil)
        }
    }
    

}
