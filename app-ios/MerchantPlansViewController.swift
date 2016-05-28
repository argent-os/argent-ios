//
//  MerchantPlansViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/27/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import XLActionController
import Alamofire
import Stripe
import SwiftyJSON
import JGProgressHUD
import JSSAlertView

class MerchantPlansViewController: UITableViewController {
    
    var detailUser: User? {
        didSet {
        }
    }
    
    let currencyFormatter = NSNumberFormatter()
    
    let merchantLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.borderWidth = 1
        self.view.layer.masksToBounds = true
        // border radius
        self.view.layer.cornerRadius = 10.0
        // border
        self.view.layer.borderColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.2).CGColor
        self.view.layer.borderWidth = 1
        // drop shadow
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.8
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        merchantLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        // merchantLabel.text = "Pay " + (detailUser?.first_name)!
        merchantLabel.textAlignment = .Center
        merchantLabel.font = UIFont(name: "DINAlternate-Bold", size: 14)
        merchantLabel.textColor = UIColor.lightGrayColor()
        self.view.addSubview(merchantLabel)
        
        //Looks for single or multiple taps.  Close keyboard on tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PayMerchantViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}