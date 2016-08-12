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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        setupNav()
    }
    
    private func configureView() {
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        let imageFingerprint = UIImageView()
        imageFingerprint.frame = CGRect(x: 140-30, y: 60, width: 60, height: 60)
        imageFingerprint.contentMode = .ScaleAspectFit
        self.view.addSubview(imageFingerprint)
        
        titleLabel.text = ""
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 18)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        ssnTextField.frame = CGRect(x: 10, y: 85, width: 260, height: 150)
        ssnTextField.placeholder = "123-45-6789"
        ssnTextField.alpha = 0.8
        ssnTextField.textAlignment = .Center
        ssnTextField.font = UIFont(name: "MyriadPro-Regular", size: 30)
        ssnTextField.textColor = UIColor.darkBlue()
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
        submitSSNButton.setBackgroundColor(UIColor.pastelBlue(), forState: .Normal)
        submitSSNButton.setBackgroundColor(UIColor.pastelBlue().darkerColor(), forState: .Highlighted)
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
                imageFingerprint.image = UIImage(named: "IconSuccess")
                imageFingerprint.frame = CGRect(x: 140-30, y: 100, width: 60, height: 60)
                self.titleLabel.text = "SSN is provided"
                self.titleLabel.frame = CGRect(x: 0, y: 165, width: 280, height: 20)
            } else {
                imageFingerprint.image = UIImage(named: "IconFingerprint")
                self.view.addSubview(self.ssnTextField)
                self.view.addSubview(self.submitSSNButton)
            }
        }
    }
    
    private func setupNav() {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar!.backgroundColor = UIColor.offWhite()
        navigationBar!.tintColor = UIColor.darkBlue()
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(self.close(_:)))
        let font = UIFont(name: "MyriadPro-Regular", size: 17)!
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkBlue()], forState: UIControlState.Highlighted)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar!.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        navigationBar!.items = [navigationItem]
        
    }
    
    func close(sender: AnyObject) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return ssnTextField.shouldChangeCharactersInRange(range, replacementString: string)
    }
    
    func submitSSN(sender: AnyObject) {
        
        addActivityIndicatorButton(UIActivityIndicatorView(), button: submitSSNButton, color: .White)
        
        if ssnTextField.text == "" || ssnTextField.text?.characters.count < 9 {
            showGlobalNotification("Invalid number provided", duration: 2.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandRed())
            return
        }
        
        let legalContent: [String: AnyObject] = [
            "personal_id_number": ssnTextField.text!,
        ]
        
        let legalJSON: [String: AnyObject] = [
            "legal_entity" : legalContent
        ]
        
        showGlobalNotification("Securely submitting ssn...", duration: 2.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.pastelBlue())
        Account.saveStripeAccount(legalJSON) { (acct, bool, err) in
            if bool {
                let _ = Timeout(2) {
                    showGlobalNotification("SSN Submitted!", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.pastelBlue())
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