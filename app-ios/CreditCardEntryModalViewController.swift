//
//  CreditCardEntryModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/2/16.
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

class CreditCardEntryModalViewController: UIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate {
    
    let titleLabel = UILabel()
    
    var submitCreditCardButton = UIButton()
    
    var paymentTextField = STPPaymentCardTextField()

    var paymentType: String?

    var planId: String?

    var detailAmount: Float?

    var detailUser: User? {
        didSet {
            // print("detail user set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set to only one instance
        
        self.view.backgroundColor = UIColor.offWhite()
        
        configureView()
    }
    
    func configureView() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        
        titleLabel.frame = CGRect(x: 0, y: 35, width: 300, height: 20)
        titleLabel.text = "Enter Credit Card"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 18)
        titleLabel.textColor = UIColor.lightBlue()
        self.view.addSubview(titleLabel)
        
        paymentTextField.frame = CGRect(x: 20, y: 105, width: 260, height: 60)
        paymentTextField.textColor = UIColor.lightBlue()
        paymentTextField.textErrorColor = UIColor.brandRed()
        paymentTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        paymentTextField.layer.cornerRadius = 10
        addSubviewWithBounce(paymentTextField, parentView: self, duration: 0.3)
        paymentTextField.becomeFirstResponder()
        
        submitCreditCardButton.frame = CGRect(x: 20, y: 230, width: 260, height: 50)
        submitCreditCardButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitCreditCardButton.layer.borderWidth = 0
        submitCreditCardButton.layer.cornerRadius = 10
        submitCreditCardButton.layer.masksToBounds = true
        submitCreditCardButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        submitCreditCardButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = NSAttributedString(string: "Submit", attributes: attribs)
        submitCreditCardButton.setAttributedTitle(str, forState: .Normal)
        submitCreditCardButton.addTarget(self, action: #selector(self.save(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitCreditCardButton)
        
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
    
    // STP PAYMENT
    
    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        submitCreditCardButton.userInteractionEnabled = false
        addActivityIndicatorButton(UIActivityIndicatorView(), button: submitCreditCardButton, color: .White)
        if let card = paymentTextField.card {
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error  {
                    print(error)
                    self.submitCreditCardButton.userInteractionEnabled = true
                }
                else if let token = token {
                    // determine whether one-time bill payment or recurring revenue payment
                    self.createBackendChargeWithToken(token) { status in
                        print(status)
                    }
                }
            }
        }
    }
    
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        if(paymentTextField.isValid) {
            paymentTextField.endEditing(true)
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        paymentTextField.endEditing(true)
    }
    
    func payMerchant(sender: AnyObject) {
        // Function for toolbar button
        // pay merchant
        showGlobalNotification("Entering card information", duration: 2.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
        let _ = Timeout(3.2) {
            showGlobalNotification("Card added", duration: 2.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
        }
        paymentTextField.clear()
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO Argent API ENDPOINT TO EXCHANGE STRIPE TOKEN
        
        //showGlobalNotification("Sending payment..." + (self.detailUser?.username)!, duration: 1.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.iosBlue())
        
        print("creating backend token")
        User.getProfile { (user, NSError) in
            print(self.detailUser?.username)
            
            let amountInCents = Int(self.detailAmount!*100)
            
            let url: String?
            if self.paymentType == "recurring" {
                url = API_URL + "/stripe/" + (user?.id)! + "/subscriptions/" + (self.detailUser?.username)!
            } else if self.paymentType == "once" {
                url = API_URL + "/stripe/" + (user?.id)! + "/charge/" + (self.detailUser?.username)!
            } else {
                url = API_URL + "/stripe/"
            }
            
            var parameters = [:]
            if self.planId != "" {
                Answers.logCustomEventWithName("Credit Card Recurring Payment Signup",
                    customAttributes: [:])
                parameters = [
                    "token": String(token) ?? "",
                    "amount": amountInCents,
                    "plan_id": self.planId!
                ]
            } else {
                Answers.logCustomEventWithName("Credit Card Single Payment",
                    customAttributes: [:])
                parameters = [
                    "token": String(token) ?? "",
                    "amount": amountInCents,
                ]
            }
            
            let headers = [
                "Authorization": "Bearer " + String(userAccessToken),
                "Content-Type": "application/json"
            ]

            print(token)
            print("posting to url", url)
            print("the parameters are", parameters)
            
            // for invalid character 0 be sure the content type is application/json and enconding is .JSON
            Alamofire.request(.POST, url!,
                parameters: parameters as? [String : AnyObject],
                encoding:.JSON,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        showGlobalNotification("Paid " + (self.detailUser?.username)! + " successfully!", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
                        if let value = response.result.value {
                            //let json = JSON(value)
                            // print(json)
                            print(PKPaymentAuthorizationStatus.Success)
                            completion(PKPaymentAuthorizationStatus.Success)
                            self.submitCreditCardButton.userInteractionEnabled = true
                            Answers.logCustomEventWithName("Credit Card Modal Entry Success",
                                customAttributes: [:])
                            let _ = Timeout(1.5) {
                                self.dismissViewControllerAnimated(true, completion: {
                                    print("dismissed")
                                })
                                self.dismissKeyboard(self)
                            }
                        }
                    case .Failure(let error):
                        print(PKPaymentAuthorizationStatus.Failure)
                        completion(PKPaymentAuthorizationStatus.Failure)
                        self.submitCreditCardButton.userInteractionEnabled = true
                        showGlobalNotification("Error paying " + (self.detailUser?.username)!, duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        Answers.logCustomEventWithName("Credit Card Entry Modal Failure",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                        print(error)
                    }
            }
        }
    }
}