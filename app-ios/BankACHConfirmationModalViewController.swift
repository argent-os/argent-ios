//
//  BankACHConfirmationModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 7/25/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import MZFormSheetPresentationController
import Crashlytics
import Alamofire
import CWStatusBarNotification
import Stripe
import M13Checkbox

class BankACHConfirmationModalViewController: UIViewController {
    
    var bankId:String?
    
    var bankFingerprint:String?
    
    var bankAccountHolderName:String?
    
    var bankAccountHolderType:String?
    
    var bankRoutingNumer:String?

    var bankVerificationStatus:String?

    var bankName:String?
    
    var bankLast4:String?
    
    var bankCountry:String?
    
    var bankCurrency:String?
    
    var consentACHCheckbox = M13Checkbox()
    
    var submitACHButton = UIButton()
    
    var detailUser: User?

    var detailAmount: Float?

    var planId: String?

    var paymentType: String?

    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    func layoutViews() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        self.navigationController?.navigationBar.topItem!.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        guard let business_name = detailUser?.business_name else {
            return
        }
        
        let confirmACHText = UILabel()
        confirmACHText.numberOfLines = 0
        confirmACHText.text = "By checking below I agree to the Argent ACH terms of service and I authorize " + business_name + " to electronically debit my account and, if necessary, electronically credit my account to correct erroneous debits. Please screenshot this page for your records."
        confirmACHText.font = UIFont(name: "SFUIText-Regular", size: 15)
        confirmACHText.textColor = UIColor.mediumBlue()
        confirmACHText.contentMode = .Center
        confirmACHText.textAlignment = .Center
        confirmACHText.lineBreakMode = .ByWordWrapping
        confirmACHText.userInteractionEnabled = true
        confirmACHText.frame = CGRect(x: 30, y: 50, width: 220, height: 130)
        addSubviewWithFade(confirmACHText, parentView: self, duration: 1)
        
        consentACHCheckbox.frame = CGRect(x: 105, y: 220, width: 70, height: 70)
        consentACHCheckbox.markType = .Checkmark
        consentACHCheckbox.stateChangeAnimation = .Spiral
        consentACHCheckbox.animationDuration = 0.5
        consentACHCheckbox.addTarget(self, action: #selector(checkState(_:)), forControlEvents: .ValueChanged)
        consentACHCheckbox.tintColor = UIColor.brandGreen()
        consentACHCheckbox.secondaryTintColor = UIColor.brandGreen().colorWithAlphaComponent(0.5)
        addSubviewWithBounce(consentACHCheckbox, parentView: self, duration: 0.8)
        
        submitACHButton.frame = CGRect(x: 0, y: 340, width: 280, height: 60)
        submitACHButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitACHButton.layer.borderWidth = 0
        submitACHButton.layer.cornerRadius = 0
        submitACHButton.layer.masksToBounds = true
        submitACHButton.setBackgroundColor(UIColor.brandGreen(), forState: .Normal)
        submitACHButton.setBackgroundColor(UIColor.brandGreen().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = adjustAttributedString("SUBMIT", spacing: 2, fontName: "SFUIText-Regular", fontSize: 14, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
        submitACHButton.setAttributedTitle(str, forState: .Normal)
        self.view.addSubview(submitACHButton)
        let rectShape = CAShapeLayer()
        rectShape.bounds = submitACHButton.frame
        rectShape.position = submitACHButton.center
        rectShape.path = UIBezierPath(roundedRect: submitACHButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 10, height: 10)).CGPath
        submitACHButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
        //Here I'm masking the textView's layer with rectShape layer
        submitACHButton.layer.mask = rectShape
        submitACHButton.addTarget(self, action: #selector(self.submit(_:)), forControlEvents: .TouchUpInside)

    }
    
    func checkState(sender: AnyObject) {
        
    }
    
    func submit(sender: AnyObject) {
        print(bankVerificationStatus)
        let bank: STPBankAccountParams = STPBankAccountParams()
        bank.accountHolderName = bankAccountHolderName
        bank.accountNumber = "000123456789" // request from user for verification, fill in last 4 digits in textfield
        bank.country = bankCountry
        bank.currency = bankCurrency
        bank.routingNumber = bankRoutingNumer
        print(bankAccountHolderType)
        bank.accountHolderType = .Company
        var token = STPAPIClient.sharedClient().createTokenWithBankAccount(bank) { (tok, err) in
            print(tok)
            print("creating token", tok)
            self.createBackendChargeWithToken(tok, completion: { (status) in
                print("num 2", tok)
                print(status)
            })
        }
//        if bankAccountHolderType! == "individual" {
//            print("bank account type individual")
//            bank.accountHolderType = .Individual
//            var token = STPAPIClient.sharedClient().createTokenWithBankAccount(bank) { (tok, err) in
//                print(tok)
//                print("creating token", tok)
//                self.createBackendChargeWithToken(tok, completion: { (status) in
//                    print("num 2", tok)
//                    print(status)
//                })
//            }
//        } else if bankAccountHolderType! == "company" {
//            print("bank account type company")
//            bank.accountHolderType = .Company
//            var token = STPAPIClient.sharedClient().createTokenWithBankAccount(bank) { (tok, err) in
//                print(tok)
//                print("creating token", tok)
//                self.createBackendChargeWithToken(tok, completion: { (status) in
//                    print("num 2", tok)
//                    print(status)
//                })
//            }
//        } else {
//            showGlobalNotification("Error loading bank details", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
//        }
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO API ENDPOINT TO EXCHANGE STRIPE TOKEN
        
        // print("creating backend charge with token")
        if 0 != 0 { // chargeInputView.text == "" || chargeInputView.text == "$0.00" {
            showGlobalNotification("Amount invalid", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
        } else {
            var str = "100" // chargeInputView.text
            str.removeAtIndex(str.characters.indices.first!) // remove first letter
            let floatValue = (str as NSString).floatValue
            let amountInCents = Int(floatValue*100)
            
            print(token)
            // print("calling create charge")
            // TODO: ACH TEMPORARY REMOVE 1000 PLACEHOLDER
            createBackendChargeWithBankAccount(token, amount: 1000)//amountInCents)
        }
    }
    
    func createBackendChargeWithBankAccount(token: STPToken, amount: Int) {
        print("creating bank ach charge")
        User.getProfile { (user, NSError) in
            print(self.detailUser?.username)
            
            let amountInCents = Int(self.detailAmount!*100)
            
            let url: String?
            if self.paymentType == "recurring" {
                url = API_URL + "/stripe/" + (user?.id)! + "/subscriptions/" + (self.detailUser?.username)! + "?type=bank"
            } else if self.paymentType == "once" {
                url = API_URL + "/stripe/" + (user?.id)! + "/charge/" + (self.detailUser?.username)! + "?type=bank"
            } else {
                url = API_URL + "/stripe/"
            }
            
            var parameters = [:]
            if self.planId != "" {
                Answers.logCustomEventWithName("ACH Recurring Payment Signup",
                    customAttributes: [:])
                parameters = [
                    "token": String(token) ?? "",
                    "amount": amountInCents,
                    "plan_id": self.planId!
                ]
            } else {
                Answers.logCustomEventWithName("ACH Single Payment",
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
            
            print("posting to url", url)
            print("the parameters are", parameters)
            
            // For invalid character 0 be sure the content type is application/json and enconding is .JSON
            // Also make sure the endpoint is right
            Alamofire.request(.POST, url!,
                parameters: parameters as? [String : AnyObject],
                encoding:.JSON,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        showGlobalNotification("Paid " + (self.detailUser?.username)! + " successfully!", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())
                        if let value = response.result.value {
                            //let json = JSON(value)
                            // print(json)
                            Answers.logCustomEventWithName("ACH Modal Entry Success",
                                customAttributes: [:])
                            let _ = Timeout(1.5) {
                                self.dismissViewControllerAnimated(true, completion: {
                                    print("dismissed")
                                })
                                self.dismissKeyboard(self)
                            }
                        }
                    case .Failure(let error):
                        showGlobalNotification("Error paying " + (self.detailUser?.username)!, duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        Answers.logCustomEventWithName("ACH Entry Modal Failure",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                        print(error)
                    }
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}