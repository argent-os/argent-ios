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

class CreditCardEntryModalViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate, STPPaymentCardTextFieldDelegate {
    
    let creditCardLogoImageView = UIImageView()
    
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
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        configureView()
        
        setupNav()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func configureView() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        self.navigationController?.navigationItem
        
        creditCardLogoImageView.frame = CGRect(x: 125, y: 90, width: 30, height: 30)
        creditCardLogoImageView.image = paymentTextField.brandImage
        creditCardLogoImageView.contentMode = .ScaleAspectFit
        self.view.addSubview(creditCardLogoImageView)
        
        let paymentMaskView = UIView()
        paymentMaskView.backgroundColor = UIColor.whiteColor()
        paymentMaskView.frame = CGRect(x: 0, y: 135, width: 42, height: 40)
        self.view.addSubview(paymentMaskView)
        self.view.bringSubviewToFront(paymentMaskView)
        self.view.superview?.bringSubviewToFront(paymentMaskView)
        
        paymentTextField.frame = CGRect(x: 0, y: 125, width: 260, height: 60)
        paymentTextField.textColor = UIColor.lightBlue()
        paymentTextField.textErrorColor = UIColor.brandRed()
        paymentTextField.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        paymentTextField.layer.cornerRadius = 10
        paymentTextField.borderWidth = 0
        paymentTextField.delegate = self
        addSubviewWithBounce(paymentTextField, parentView: self, duration: 0.3)
        paymentTextField.becomeFirstResponder()
        self.view.sendSubviewToBack(paymentTextField)
        
        submitCreditCardButton.userInteractionEnabled = false
        submitCreditCardButton.frame = CGRect(x: 0, y: 220, width: 280, height: 60)
        submitCreditCardButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitCreditCardButton.layer.borderWidth = 0
        submitCreditCardButton.layer.cornerRadius = 0
        submitCreditCardButton.layer.masksToBounds = true
        submitCreditCardButton.setBackgroundColor(UIColor.lightBlue().lighterColor(), forState: .Normal)
        submitCreditCardButton.setBackgroundColor(UIColor.lightBlue().lighterColor(), forState: .Highlighted)
        var attribs: [String: AnyObject] = [:]
        attribs[NSFontAttributeName] = UIFont(name: "SFUIText-Regular", size: 14)
        attribs[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let str = adjustAttributedString("SUBMIT", spacing: 2, fontName: "SFUIText-Regular", fontSize: 14, fontColor: UIColor.whiteColor(), lineSpacing: 0.0, alignment: .Center)
        submitCreditCardButton.setAttributedTitle(str, forState: .Normal)
        submitCreditCardButton.addTarget(self, action: #selector(self.save(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(submitCreditCardButton)
        let rectShape = CAShapeLayer()
        rectShape.bounds = submitCreditCardButton.frame
        rectShape.position = submitCreditCardButton.center
        rectShape.path = UIBezierPath(roundedRect: submitCreditCardButton.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 10, height: 10)).CGPath
        
        submitCreditCardButton.layer.backgroundColor = UIColor.mediumBlue().CGColor
        //Here I'm masking the textView's layer with rectShape layer
        submitCreditCardButton.layer.mask = rectShape
        
    }
    
    private func setupNav() {
        let navigationBar = self.navigationController?.navigationBar
        
        navigationBar!.backgroundColor = UIColor.offWhite()
        navigationBar!.tintColor = UIColor.darkBlue()
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(self.close(_:)))
//        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close(_:)))
        let font = UIFont(name: "SFUIText-Regular", size: 17)!
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkBlue()], forState: UIControlState.Highlighted)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "IconScanCamera"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.scanCard(_:)))
        rightButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar!.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        navigationBar!.items = [navigationItem]

    }
    
    func close(sender: AnyObject) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        paymentTextField.becomeFirstResponder()
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
        // print(paymentTextField.brandImage)
        creditCardLogoImageView.alpha = 1
        creditCardLogoImageView.image = paymentTextField.brandImage
        if(paymentTextField.isValid) {
            submitCreditCardButton.setBackgroundColor(UIColor.brandGreen(), forState: .Normal)
            submitCreditCardButton.setBackgroundColor(UIColor.brandGreen().lighterColor(), forState: .Highlighted)
            submitCreditCardButton.userInteractionEnabled = true
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
            
            let uat = userAccessToken
            let _ = uat.map { (unwrapped_access_token) -> Void in
                let headers = [
                    "Authorization": "Bearer " + String(unwrapped_access_token),
                    "Content-Type": "application/json"
                ]
                
                // print(token)
                // print("posting to url", url)
                // print("the parameters are", parameters)
                
                // for invalid character 0 be sure the content type is application/json and enconding is .JSON
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
}


extension CreditCardEntryModalViewController: CardIOPaymentViewControllerDelegate {
    // CARD IO
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.hideCardIOLogo = true
        cardIOVC.collectPostalCode = true
        cardIOVC.allowFreelyRotatingCardGuide = true
        cardIOVC.guideColor = UIColor.skyBlue()
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        //        resultLabel.text = "Card not entered"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didScanCard(cardInfo: CardIOCreditCardInfo) {
        // The full card number is available as info.cardNumber, but don't log that!
        // print("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", cardInfo.redactedCardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv);
        // Use the card info...
        // Post to Stripe, make API call here
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            paymentTextField.cardParams = card
            let _ = Timeout(0.2) {
                self.paymentTextField.endEditing(true)
            }
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
