//
//  IdentitySSNModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/2/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import VMaskTextField
import CWStatusBarNotification
import Crashlytics

class IdentitySSNModalViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel = UILabel()
    
    let ssnTextField = VMaskTextField()
    
    let submitSSNButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.offWhite()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 280, height: 20)
        titleLabel.text = "Enter your SSN"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 18)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        ssnTextField.frame = CGRect(x: 10, y: 70, width: 260, height: 150)
        ssnTextField.placeholder = "xxx-xx-xxxx"
        ssnTextField.alpha = 0.8
        ssnTextField.textAlignment = .Center
        ssnTextField.font = UIFont(name: "MyriadPro-Regular", size: 20)
        ssnTextField.textColor = UIColor.lightBlue()
//        ssnTextField.mask = "###-##-####"
        ssnTextField.mask = "#########"
        ssnTextField.delegate = self
        ssnTextField.keyboardType = .NumberPad
        ssnTextField.secureTextEntry = true
        ssnTextField.becomeFirstResponder()
        
        submitSSNButton.frame = CGRect(x: 0, y: 220, width: 280, height: 60)
        submitSSNButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitSSNButton.layer.borderWidth = 0
        submitSSNButton.layer.cornerRadius = 0
        submitSSNButton.layer.masksToBounds = true
        submitSSNButton.setBackgroundColor(UIColor.iosBlue(), forState: .Normal)
        submitSSNButton.setBackgroundColor(UIColor.iosBlue().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 15)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Submit", attributes: attribs)
        submitSSNButton.setAttributedTitle(str, forState: .Normal)
        submitSSNButton.addTarget(self, action: #selector(self.submitSSN(_:)), forControlEvents: .TouchUpInside)
        let rectShape = CAShapeLayer()
        rectShape.bounds = submitSSNButton.frame
        rectShape.position = submitSSNButton.center
        rectShape.path = UIBezierPath(roundedRect: submitSSNButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 5, height: 5)).CGPath
        
        submitSSNButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
        //Here I'm masking the textView's layer with rectShape layer
        submitSSNButton.layer.mask = rectShape
        
        Account.getStripeAccount { (acct, err) in
            //
            if (acct?.pin)! == true {
                self.titleLabel.text = "Your SSN is already provided"
            } else {
                self.view.addSubview(self.ssnTextField)
                self.view.addSubview(self.submitSSNButton)
            }
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return ssnTextField.shouldChangeCharactersInRange(range, replacementString: string)
    }
    
    func submitSSN(sender: AnyObject) {
        
        addActivityIndicatorButton(UIActivityIndicatorView(), button: submitSSNButton, color: .White)
        
        let legalContent: [String: AnyObject] = [
            "personal_id_number": ssnTextField.text!,
        ]
        
        let legalJSON: [String: AnyObject] = [
            "legal_entity" : legalContent
        ]
        
        showGlobalNotification("Securely confirming ssn...", duration: 2.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
        Account.saveStripeAccount(legalJSON) { (acct, bool, err) in
            if bool {
                let _ = Timeout(2) {
                    showGlobalNotification("SSN Confirmed!", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                Answers.logCustomEventWithName("Identity Verification SSN Upload Success",
                                               customAttributes: [:])
            } else {
                showGlobalNotification("An error occurred", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
                Answers.logCustomEventWithName("Identity Verification SSN Upload Failure",
                                               customAttributes: [:])
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}