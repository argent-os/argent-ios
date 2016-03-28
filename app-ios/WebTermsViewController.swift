//
//  WebTermsViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebTermsViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var containerView : UIView!
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.webView?.UIDelegate = self
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:"http://www.protonpayments.com/home")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}