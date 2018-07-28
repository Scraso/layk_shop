//
//  LoginViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 5/21/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging

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
    
    // MARK: - Helpers
    
    
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
    
    // Post user token to Firestore
    func postToken(token: [String: Any]) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_FCM_TOKEN.document(currentUserUid).setData(token)
    }
    
    
    // MARK: - Actions
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        let token: [String: Any] = [Messaging.messaging().fcmToken ?? "": Messaging.messaging().fcmToken as Any]
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            self.shakeView()
                        } else {
                            self.postToken(token: token)
                            // Add userBadge collection and set count to 0
                            DataService.instance.REF_USER_BADGE_COUNT.addDocument(data: ["count": 0])
                            // Create user collection and save email
                            DataService.instance.REF_USERS.document(user?.user.uid ?? "").setData(["email": user?.user.email ?? ""])
                            print("User successfully created.")
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } else {
                    self.postToken(token: token)
                    self.dismiss(animated: true, completion: nil)
                    print("User logged in")
                }
            }
        }
    }

    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        
    }
    
}
