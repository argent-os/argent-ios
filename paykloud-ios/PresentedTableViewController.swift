//
//  PresentedTableViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import SafariServices
import MZFormSheetPresentationController

class PresentedTableViewController: UIViewController {
    

    @IBOutlet weak var stripeButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var textFieldBecomeFirstResponder: Bool = false
    var passingString1: String?
    var passingString2: String?
    var acceptStatus: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsButton.layer.cornerRadius = 5
        privacyButton.layer.cornerRadius = 5
        stripeButton.layer.cornerRadius = 5

        // This will set to only one instance
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("close"))
        
        if let text1 = self.passingString1 {
            //print(text1)
            // self.textField.text = text;
        }
        if let text2 = self.passingString2 {
            //print(text2)
            // self.textField.text = text;
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if textFieldBecomeFirstResponder {
//            self.textField.becomeFirstResponder()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "termsView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "http://www.google.com")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            if identifier == "privacyView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "http://www.google.com")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.google.com")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            if identifier == "stripeView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "https://stripe.com/connect/account-terms")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://stripe.com/connect/account-terms")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
}