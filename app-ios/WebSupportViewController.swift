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
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default

        let app: UIApplication = UIApplication.sharedApplication()
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusBarView: UIView = UIView(frame: CGRectMake(0, -statusBarHeight, UIScreen.mainScreen().bounds.size.width, statusBarHeight))
        statusBarView.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.addSubview(statusBarView)
        self.navigationController?.navigationBar.bringSubviewToFront(statusBarView)
        
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 60)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let app: UIApplication = UIApplication.sharedApplication()
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusBarView: UIView = UIView(frame: CGRectMake(0, -statusBarHeight, UIScreen.mainScreen().bounds.size.width, statusBarHeight))
        statusBarView.backgroundColor = UIColor.pastelBlue()
        self.navigationController?.navigationBar.addSubview(statusBarView)
        self.navigationController?.navigationBar.bringSubviewToFront(statusBarView)
        
        // THIS SETS STATUS BAR COLOR
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.mainScreen().bounds.width, height: 40)
        self.navigationController?.navigationBar.backgroundColor = UIColor.pastelBlue()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationItem.title = "Argent Help Center"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
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