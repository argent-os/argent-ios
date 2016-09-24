//
//  BankACHConfirmationModalViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 9/23/16.
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
    
    let currencyFormatter: NSNumberFormatter = NSNumberFormatter()
    
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
    
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
        
        let bankImage = UIImageView()
        bankImage.contentMode = .Center
        bankImage.contentMode = .ScaleAspectFit
        bankImage.userInteractionEnabled = true
        bankImage.frame = CGRect(x: 105, y: 80, width: 70, height: 70)
        addSubviewWithFade(bankImage, parentView: self, duration: 1)
        
        if bankName!.containsString("STRIPE") {
            bankImage.image = UIImage(named: "bank_avatar_stripe")
        } else if bankName!.containsString("BANK OF AMERICA") {
            bankImage.image = UIImage(named: "bank_avatar_bofa")
        } else if bankName!.containsString("CITI") {
            bankImage.image = UIImage(named: "bank_avatar_citi")
        } else if bankName!.containsString("WELLS") {
            bankImage.image = UIImage(named: "bank_avatar_wells")
        } else if bankName!.containsString("TD BANK") {
            bankImage.image = UIImage(named: "bank_avatar_td")
        } else if bankName!.containsString("US BANK") {
            bankImage.image = UIImage(named: "bank_avatar_us")
        } else if bankName!.containsString("PNC") {
            bankImage.image = UIImage(named: "bank_avatar_pnc")
        } else if bankName!.containsString("AMERICAN EXPRESS") {
            bankImage.image = UIImage(named: "bank_avatar_amex")
        } else if bankName!.containsString("NAVY") {
            bankImage.image = UIImage(named: "bank_avatar_navy")
        } else if bankName!.containsString("USAA") {
            bankImage.image = UIImage(named: "bank_avatar_usaa")
        } else if bankName!.containsString("CHASE") {
            bankImage.image = UIImage(named: "bank_avatar_chase")
        } else if bankName!.containsString("CAPITAL ONE") {
            bankImage.image = UIImage(named: "bank_avatar_capone")
        } else if bankName!.containsString("SCHWAB") {
            bankImage.image = UIImage(named: "bank_avatar_schwab")
        } else if bankName!.containsString("FIDELITY") {
            bankImage.image = UIImage(named: "bank_avatar_fidelity")
        } else if bankName!.containsString("SUNTRUST") {
            bankImage.image = UIImage(named: "bank_avatar_suntrust")
        } else {
            bankImage.image = UIImage(named: "bank_avatar_default")
        }
        
        let confirmACHText = UILabel()
        confirmACHText.numberOfLines = 0
        confirmACHText.attributedText = adjustAttributedString("ENDING IN " + bankLast4!, spacing: 2, fontName: "SFUIText-Regular", fontSize: 14, fontColor: UIColor.mediumBlue(), lineSpacing: 0.0, alignment: .Center)
        confirmACHText.textColor = UIColor.mediumBlue()
        confirmACHText.contentMode = .Center
        confirmACHText.textAlignment = .Center
        confirmACHText.lineBreakMode = .ByWordWrapping
        confirmACHText.userInteractionEnabled = true
        confirmACHText.frame = CGRect(x: 30, y: 110, width: 220, height: 130)
        addSubviewWithFade(confirmACHText, parentView: self, duration: 1)
        
//        consentACHCheckbox.frame = CGRect(x: 105, y: 220, width: 70, height: 70)
//        consentACHCheckbox.markType = .Checkmark
//        consentACHCheckbox.stateChangeAnimation = .Spiral
//        consentACHCheckbox.animationDuration = 0.5
//        consentACHCheckbox.addTarget(self, action: #selector(checkState(_:)), forControlEvents: .ValueChanged)
//        consentACHCheckbox.tintColor = UIColor.brandGreen()
//        consentACHCheckbox.secondaryTintColor = UIColor.brandGreen().colorWithAlphaComponent(0.5)
//        addSubviewWithBounce(consentACHCheckbox, parentView: self, duration: 0.8)
        
        submitACHButton.frame = CGRect(x: 0, y: 220, width: 280, height: 60)
        submitACHButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitACHButton.layer.borderWidth = 0
        submitACHButton.layer.cornerRadius = 0
        submitACHButton.layer.masksToBounds = true
        submitACHButton.setBackgroundColor(UIColor.brandGreen(), forState: .Normal)
        submitACHButton.setBackgroundColor(UIColor.brandGreen().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        
        // TODO: FIX HACKINESS
        if paymentType == "once" {
            let str = adjustAttributedString("PAY " + currencyStringFromNumber(Double(detailAmount!)), spacing: 2, fontName: "SFUIText-Regular", fontSize: 14, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
            submitACHButton.setAttributedTitle(str, forState: .Normal)

        } else if paymentType == "recurring" {
            let str = adjustAttributedString("PAY " + currencyStringFromNumber(Double(detailAmount!/100)), spacing: 2, fontName: "SFUIText-Regular", fontSize: 14, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
            submitACHButton.setAttributedTitle(str, forState: .Normal)

        }
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
    
    func submit(sender: AnyObject) {
        createBackendChargeWithBankAccount(Int(self.detailAmount!*100))
    }
    

    func createBackendChargeWithBankAccount(amount: Int) {
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
                    "source": self.bankId!,
                    "amount": amountInCents,
                    "plan_id": self.planId!
                ]
            } else {
                Answers.logCustomEventWithName("ACH Single Payment",
                    customAttributes: [:])
                parameters = [
                    "source": self.bankId!,
                    "amount": amountInCents,
                ]
            }
            
            // Be sure to unwrap the userAccessToken or [SyntaxError: Unexpected token :] will occur
            let headers = [
                "Authorization": "Bearer " + String(userAccessToken!),
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
                        showGlobalNotification("Paid " + (self.detailUser?.username)! + " successfully!", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
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