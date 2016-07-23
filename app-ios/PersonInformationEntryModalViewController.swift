//
//  PersonInformationEntryModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/5/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetPresentationController
import Stripe
import CWStatusBarNotification
import Alamofire
import SwiftyJSON
import Crashlytics

class PersonInformationEntryModalViewController: UIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate {
    
    let titleLabel = UILabel()
    
    var submitInformationButton = UIButton()
    
    var informationTextField = UITextField()

    var detailAmount: Int?
    
    let yesButton = UIButton()

    let noButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        configureView()
    }
    
    func configureView() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.mediumBlue(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 18.0)!
        ]
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Would you like a receipt?"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 18)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        informationTextField.frame = CGRect(x: 20, y: 105, width: 260, height: 60)
        informationTextField.textColor = UIColor.lightBlue()
        informationTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        informationTextField.layer.cornerRadius = 10
        informationTextField.layer.borderWidth = 0
        informationTextField.textAlignment = .Center
        informationTextField.autocapitalizationType = .None
        informationTextField.autocorrectionType = .No
        informationTextField.keyboardType = .EmailAddress
        informationTextField.becomeFirstResponder()

        submitInformationButton.frame = CGRect(x: 20, y: 230, width: 260, height: 50)
        submitInformationButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitInformationButton.layer.borderWidth = 0
        submitInformationButton.layer.cornerRadius = 10
        submitInformationButton.layer.masksToBounds = true
        submitInformationButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        submitInformationButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Submit", attributes: attribs)
        submitInformationButton.setAttributedTitle(str, forState: .Normal)
        submitInformationButton.addTarget(self, action: #selector(self.configureBeforeSendingReceipt(_:)), forControlEvents: .TouchUpInside)
        
        yesButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        yesButton.frame = CGRect(x: 60, y: 180, width: 180, height: 50)
        let yesStr = NSAttributedString(string: "Yes please!", attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightThin),
            NSForegroundColorAttributeName:UIColor.whiteColor()
        ])
        let yesStr2 = NSAttributedString(string: "Yes please!", attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightThin),
            NSForegroundColorAttributeName:UIColor.whiteColor().colorWithAlphaComponent(0.5)
        ])
        yesButton.setAttributedTitle(yesStr, forState: .Normal)
        yesButton.setAttributedTitle(yesStr2, forState: .Highlighted)
        yesButton.layer.cornerRadius = 10
        yesButton.layer.masksToBounds = true
        yesButton.addTarget(self, action: #selector(yesClicked(_:)), forControlEvents: .TouchUpInside)
        addSubviewWithBounce(yesButton, parentView: self, duration: 0.3)
        
        
        noButton.setBackgroundColor(UIColor.whiteColor(), forState: .Normal)
        noButton.setBackgroundColor(UIColor.whiteColor(), forState: .Highlighted)
        noButton.frame = CGRect(x: 20, y: 240, width: 260, height: 50)
        let noStr = NSAttributedString(string: "No thanks", attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName:UIColor.lightBlue()
        ])
        let noStr2 = NSAttributedString(string: "No thanks", attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(14, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName:UIColor.lightBlue().colorWithAlphaComponent(0.5)
        ])
        noButton.setAttributedTitle(noStr, forState: .Normal)
        noButton.setAttributedTitle(noStr2, forState: .Highlighted)
        noButton.addTarget(self, action: #selector(noClicked(_:)), forControlEvents: .TouchUpInside)
        addSubviewWithBounce(noButton, parentView: self, duration: 0.3)
        
    }
    
    func yesClicked(sender: AnyObject) {
        addSubviewWithBounce(informationTextField, parentView: self, duration: 0.3)
        addSubviewWithBounce(submitInformationButton, parentView: self, duration: 0.3)
        yesButton.removeFromSuperview()
        noButton.removeFromSuperview()
        titleLabel.text = "Please enter your email"
    }
    
    func noClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            //
        }
    }

    func submitCreditCard(sender: AnyObject) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func close() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        informationTextField.endEditing(true)
    }
    
    func configureBeforeSendingReceipt(sender: AnyObject) {
        addActivityIndicatorButton(UIActivityIndicatorView(), button: submitInformationButton, color: .White)
        if informationTextField.text != "" && detailAmount != 0 {
            print("sending email receipt")
            self.sendInformation(self, email: informationTextField.text!, amount: detailAmount!)
        } else {
            showGlobalNotification("Amount nil or email empty!", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
        }
    }
    
    func sendInformation(sender: AnyObject, email: String, amount: Int) {
        // SEND REQUEST TO Argent API ENDPOINT TO SEND RECEIPT
        
        User.getProfile { (user, err) in
            
            let headers : [String : String] = [
                "Content-Type": "application/json"
            ]
            
            let amt = Float(amount)/100
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            let strAmt = formatter.stringFromNumber(amt) // "$123.44"

            let parameters = [
                "message": "Hello! \n\n This is an email receipt for a recent transaction made on Argent in the amount of " + strAmt! + " on " + NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            ]
            
            print("customer email is", email)
            // /v1/receipt/8s9g8a0sd9asdjk2/customer?email=john@doe.com
            Alamofire.request(.POST, API_URL + "/receipts/" + (user?.id)! + "/customer?email=" + email, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { (response) in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            //let data = JSON(value)
                            showGlobalNotification("Receipt sent!", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
                            self.informationTextField.text = ""
                            Answers.logCustomEventWithName("Receipt Sent Success",
                                customAttributes: [
                                    "to_email": email
                                ])
                            self.dismissViewControllerAnimated(true) {
                                //
                            }
                        }
                    case .Failure(let error):
                        print(error)
                        showGlobalNotification("Error sending receipt", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        Answers.logCustomEventWithName("Receipt Failed to Send",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                        self.dismissViewControllerAnimated(true) {
                            //
                        }
                    }
            }
        }
    }    
}
