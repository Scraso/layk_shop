//
//  HomeViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/18/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.alpha = 0
        
        UIView.animate(withDuration: 1) {
           self.logoImageView.alpha = 1
        }

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        scrollView.delegate = self
        
        checkIfUserIsSignedIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // Check if user is logged in and if yes then change loggin button to logout
    
    private func checkIfUserIsSignedIn() {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.loginBtn.title = "Logout"
            } else {
                self.loginBtn.title = "Login"
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginBtnTapped(_ sender: UIBarButtonItem) {
        if loginBtn.title == "Logout" {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                loginBtn.title = "Login"
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            headerView.transform = CGAffineTransform(translationX: 0, y: offsetY)
            logoImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
            backgroundImageView.transform = CGAffineTransform(translationX: 0, y: -offsetY/5)
        }
        
        let navigationIsHidden = offsetY <= 0
        navigationController?.setNavigationBarHidden(navigationIsHidden, animated: true)
    }
}
