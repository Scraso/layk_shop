//
//  WebViewController.swift
//  layk_shop
//
//  Created by Tigran Ambarcumyan on 7/3/18.
//  Copyright © 2018 Tigran Ambarcumyan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var urlString: String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        // Add observer to listen for the progress
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1.0 {
                navigationItem.title = webView.title
            } else {
                navigationItem.title = "Loading..."
            }
        }
    }
    
    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func actionBtnTapped(_ sender: UIBarButtonItem) {
        
        let activityItems = [urlString] as! Array<String>
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [.postToFacebook]
        
        present(activityController, animated: true, completion: nil)
    }
    @IBAction func safariBtnTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL(string: urlString)!)
    }
    @IBAction func backBtnTaped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    @IBAction func forwardBtnTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    @IBAction func reloadBtnTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
}
