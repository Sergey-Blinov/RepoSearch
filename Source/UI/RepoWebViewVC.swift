//
//  RepoWebViewVC.swift
//  RepoWebViewVC
//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

class RepoWebViewVC: UIViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var dismissButton: UIButton!
    @IBOutlet var webView: UIWebView!
    
    var stringUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebPage()
    }

    @IBAction func dismissButtonPressed(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadWebPage() -> Void {
        guard let stringUrl = self.stringUrl, let url = URL(string: stringUrl) else { return }
        self.webView.delegate = self
        self.webView.loadRequest(URLRequest(url:url))
    }
}

extension RepoWebViewVC: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activityIndicatorView.stopAnimating()
    }
}



