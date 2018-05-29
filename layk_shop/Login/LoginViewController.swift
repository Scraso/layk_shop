//
//  LoginViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var panToClose: InteractionPanToClose!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        panToClose.setGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        panToClose.animateDialogAppear()
        
    }
    
    
    // Animate view shake when client uses wrong credentials
    func shakeView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.loginView.transform = CGAffineTransform(translationX: 50, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
                self?.loginView.transform = .identity
                },
                           completion: nil)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    if error != nil {
                        self.shakeView()
                    } else {
                        print("User successfully created.")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else {
                self.dismiss(animated: true, completion: nil)
                print("User logged in")
            }
        }
        
    }

    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        
    }
    
}
