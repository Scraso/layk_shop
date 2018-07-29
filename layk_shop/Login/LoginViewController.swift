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

    @IBOutlet var loginViewPanToClose: InteractionPanToClose!
    @IBOutlet var resetPasswordViewPanToClose: InteractionPanToClose!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var resetEmailTextField: UITextField!
    @IBOutlet weak var resetPasswordTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginViewPanToClose.setGestureRecognizer(isEnabled: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginViewPanToClose.animateDialogAppear()
        
    }
    
    // MARK: - Helpers
    
    
    // Animate view shake when client uses wrong details
    func shakeLoginView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.loginView.transform = CGAffineTransform(translationX: 50, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
                self?.loginView.transform = .identity
                },
                           completion: nil)
        })
    }
    
    // Animate view shake when client uses wrong credentials
    func shakeResetPasswordView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.resetPasswordView.transform = CGAffineTransform(translationX: 50, y: 0)
        }, completion: { _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: { [weak self] in
                self?.resetPasswordView.transform = .identity
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
                            self.shakeLoginView()
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
    
    let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        UIView.transition(with: loginView, duration: 0.6, options: transitionOptions, animations: {
            self.loginView.isHidden = true
            self.loginViewPanToClose.setGestureRecognizer(isEnabled: false)
        })
        
        UIView.transition(with: resetPasswordView, duration: 0.6, options: transitionOptions, animations: {
            self.resetPasswordView.isHidden = false
            self.resetPasswordViewPanToClose.setGestureRecognizer(isEnabled: true)
        })
    }
    
    @IBAction func backToLoginBtnTapped(_ sender: UIButton) {
        UIView.transition(with: loginView, duration: 0.6, options: transitionOptions, animations: {
            self.loginView.isHidden = false
            self.loginViewPanToClose.setGestureRecognizer(isEnabled: true)
        })
        
        UIView.transition(with: resetPasswordView, duration: 0.6, options: transitionOptions, animations: {
            self.resetPasswordView.isHidden = true
            self.resetPasswordViewPanToClose.setGestureRecognizer(isEnabled: false)
        })
    }
    @IBAction func sendPasswordBtnTapped(_ sender: UIButton) {
        // Change language when user follow the reset passowrd link
        Auth.auth().languageCode = "ru"
        if let email = resetEmailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    print("Reset password failed: \(error)")
                    self.handleError(error)
                    return
                } else {
                    Auth.auth().useAppLanguage()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .userNotFound:
            return "Электронный адрес не найден"
        case .networkError:
            return "Ошибка сети. Пожалуйста, попробуйте еще раз"
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Некорректный адрес электронный почты"
        default:
            return "Неизвестная ошибка. Попробуйте позже"
        }
    }
}

extension LoginViewController {
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            resetPasswordTextView.text = errorCode.errorMessage
            resetPasswordTextView.textColor = UIColor.init(red: 255/255, green: 59/255, blue: 48/255, alpha: 100)
            shakeResetPasswordView()
        }
    }
    
}
