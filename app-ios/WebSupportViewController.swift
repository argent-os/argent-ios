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
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 60)
        self.navigationController?.navigationBar.backgroundColor = UIColor.slateBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationItem.title = "Argent Help Center"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let url = NSURL(string:"https://argentapp.zendesk.com/hc/en-us")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}