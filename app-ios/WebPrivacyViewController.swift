//
//  WebPrivacyViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import SVProgressHUD

class WebPrivacyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.webView?.UIDelegate = self
        self.webView?.contentMode = UIViewContentMode.ScaleToFill
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string:"http://www.protonpayments.com/privacy")
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var previewActions: [UIPreviewActionItem] = {
        func previewActionForTitle(title: String, style: UIPreviewActionStyle = .Default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                //                guard let detailViewController = viewController as? DetailViewController,
                //                    item = detailViewController.detailItemTitle else { return }
                //                print("\(previewAction.title) triggered from `DetailViewController` for item: \(item)")
                if title == "Copy Link" {
                    UIPasteboard.generalPasteboard().string = "http://www.protonpayments.com/privacy"
                    SVProgressHUD.showSuccessWithStatus("Link Copied!")
                }
                if title == "Share" {
                    let activityViewController  = UIActivityViewController(
                        activityItems: ["Proton Payments Privacy Policy  http://www.protonpayments.com/privacy" as NSString],
                        applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                    self.presentViewController(activityViewController, animated: true, completion: nil)
                }
            }
        }
        
        let action1 = previewActionForTitle("Copy Link")
        let action2 = previewActionForTitle("Share")
        return [action1, action2]
        
        //        let action2 = previewActionForTitle("Share", style: .Destructive)
        //        let subAction1 = previewActionForTitle("Sub Action 1")
        //        let subAction2 = previewActionForTitle("Sub Action 2")
        //        let groupedActions = UIPreviewActionGroup(title: "More", style: .Default, actions: [subAction1, subAction2] )
        //        return [action1, action2, groupedActions]
        
    }()
    
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        return previewActions
    }
    
}