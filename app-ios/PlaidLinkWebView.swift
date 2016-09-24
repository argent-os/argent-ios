//
//  PlaidLinkWebView.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CWStatusBarNotification
import SwiftyJSON

class PlaidLinkWebView: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    @IBOutlet var containerView : UIView!
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.width
        let screenHeight = screen.height
        
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        controller.addScriptMessageHandler(self, name: "observe")
        configuration.userContentController = controller
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), configuration: configuration)
        self.webView?.contentMode = .ScaleAspectFit
        self.webView?.UIDelegate = self
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ENVIRONMENT == "DEV" {
            let url = NSURL(string:"http://localhost:5000/link")
            let req = NSURLRequest(URL:url!)
            self.webView!.loadRequest(req)
        } else if ENVIRONMENT == "PROD" {
            let url = NSURL(string:"https://www.argentapp.com/link")
            let req = NSURLRequest(URL:url!)
            self.webView!.loadRequest(req)
        }

    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        // print("Received event \(message.body)")
        // convert the json to an nsdict

        let _ = String(message.body["access_token"].map({ (unwrap) -> () in
            //self.updateUserPlaidToken(unwrap)
        }))
        let _ = String(message.body["stripe_bank_account_token"].map({ (unwrap) -> () in
            //self.linkBankToStripe(unwrap)
        }))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}