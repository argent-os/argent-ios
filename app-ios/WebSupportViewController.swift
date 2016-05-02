//
//  WebSupportViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebSupportViewController: UIViewController {
    
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()

        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:"http://www.argentapp.com/home")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}