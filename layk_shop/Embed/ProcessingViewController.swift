//
//  ProcessingViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 6/18/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit


class ProcessingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToCart", sender: self)
        
    }
    

}
