//
//  ChargeViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Stripe
import JSSAlertView
import MZFormSheetPresentationController
import QRCode
import CWStatusBarNotification
import SwiftyJSON
import Alamofire

class ChargeViewController: UIViewController, STPPaymentCardTextFieldDelegate, UITextFieldDelegate, UINavigationBarDelegate {
    
    let chargeInputView = UITextField()

    let currencyFormatter = NSNumberFormatter()
    
    var paymentTextField = STPPaymentCardTextField()
    
    let notification = CWStatusBarNotification()

    let payButton = UIButton()

    func textFieldDidChange(textField: UITextField) {
        let text = textField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator, withString: "")
        textField.text = currencyFormatter.stringFromNumber((text as NSString).doubleValue / 100.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    override func viewDidAppear(animated: Bool) {
        chargeInputView.becomeFirstResponder()
        super.viewDidAppear(true)
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.offWhite()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Argent Payment Terminal"
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func configure() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.view.backgroundColor = UIColor.offWhite()
        
        // addDoneToolbar()
        
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: 80, width: screenWidth, height: 65)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont(name: "DINAlternate-Bold", size: 48)
        chargeInputView.textColor = UIColor.lightBlue()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        Timeout(0.2) {
            addSubviewWithBounce(self.chargeInputView, parentView: self, duration: 0.3)
        }
        
        // Pay with bitcoin button
        let payWithBitcoinButton = UIButton(frame: CGRect(x: 20, y: 180, width: screenWidth/2-20-10, height: 60.0))
        payWithBitcoinButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        payWithBitcoinButton.setBackgroundColor(UIColor.offWhite().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithBitcoinButton.tintColor = UIColor.lightBlue()
        payWithBitcoinButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        payWithBitcoinButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithBitcoinButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 13)
        payWithBitcoinButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        payWithBitcoinButton.layer.borderWidth = 1
        payWithBitcoinButton.layer.cornerRadius = 10
        payWithBitcoinButton.layer.masksToBounds = true
        payWithBitcoinButton.setTitle("Pay with Bitcoin", forState: .Normal)
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.addTarget(self, action: #selector(ChargeViewController.payWithBitcoin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.3) {
            addSubviewWithBounce(payWithBitcoinButton, parentView: self, duration: 0.3)
        }
        
        // Pay with card button
        let payWithCardButton = UIButton(frame: CGRect(x: screenWidth/2+10, y: 180, width: screenWidth/2-20-10, height: 60.0))
        payWithCardButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        payWithCardButton.setBackgroundColor(UIColor.offWhite().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithCardButton.tintColor = UIColor.lightBlue()
        payWithCardButton.setTitleColor(UIColor.lightBlue(), forState: .Normal)
        payWithCardButton.setTitleColor(UIColor.lightBlue().colorWithAlphaComponent(0.5), forState: .Highlighted)
        payWithCardButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 13)
        payWithCardButton.layer.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5).CGColor
        payWithCardButton.layer.borderWidth = 1
        payWithCardButton.layer.cornerRadius = 10
        payWithCardButton.layer.masksToBounds = true
        payWithCardButton.setTitle("Pay with Card", forState: .Normal)
        payWithCardButton.clipsToBounds = true
        payWithCardButton.addTarget(self, action: #selector(ChargeViewController.payWithCard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.5) {
            addSubviewWithBounce(payWithCardButton, parentView: self, duration: 0.3)
        }
        
        // Pay button
        payButton.frame = CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0)
        payButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        payButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.75), forState: .Highlighted)
        payButton.tintColor = UIColor(rgba: "#fff")
        payButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        payButton.setTitleColor(UIColor(rgba: "#fffe"), forState: .Highlighted)
        payButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 14)
        payButton.setTitle("Pay Merchant", forState: .Normal)
        payButton.layer.cornerRadius = 10
        payButton.layer.masksToBounds = true
        payButton.clipsToBounds = true
        payButton.addTarget(self, action: #selector(ChargeViewController.save(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.6) {
            addSubviewWithFade(self.payButton, parentView: self, duration: 1)
        }
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }

    // STRIPE SAVE METHOD
    @IBAction func save(sender: UIButton) {
        payButton.userInteractionEnabled = false
        addActivityIndicatorButton(UIActivityIndicatorView(), button: payButton, color: .White)
        
        // print("save called")
        // print(chargeInputView.text)
        showGlobalNotification("Paying merchant " + chargeInputView.text!, duration: 1.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())

        if(chargeInputView.text != "" || chargeInputView.text != "$0.00") {
            // print("civ passes check")
            if let card = paymentTextField.card {
                // print("got card")
                STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                    if let error = error  {
                        print(error)
                    }
                    else if let token = token {
                        print("got token")
                        self.createBackendChargeWithToken(token) { status in
                            // print(status)
                        }
                    }
                }
            }
        } else {
            print("failed")
            payButton.userInteractionEnabled = true
            showGlobalNotification("Invalid Amount" + chargeInputView.text!, duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.neonOrange())
        }
    }
    
    func createBackendChargeWithToken(token: STPToken!, completion: PKPaymentAuthorizationStatus -> ()) {
        // SEND REQUEST TO API ENDPOINT TO EXCHANGE STRIPE TOKEN

        // print("creating backend charge with token")
        if(chargeInputView.text == "" || chargeInputView.text == "$0.00") {
            showGlobalNotification("Amount invalid", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
        } else {
            var str = chargeInputView.text
            str?.removeAtIndex(str!.characters.indices.first!) // remove first letter
            let floatValue = (str! as NSString).floatValue
            let amountInCents = Int(floatValue*100)

            // print("calling create charge")
            createCharge(token, amount: amountInCents)
        }
    }
    
    func createCharge(token: STPToken, amount: Int) {
        
        // print("creating backend token")
        User.getProfile { (user, NSError) in
            let url = API_URL + "/v1/stripe/" + (user?.id)! + "/charge/"
            
            let headers = [
                "Authorization": "Bearer " + String(userAccessToken),
                "Content-Type": "application/json"
            ]
            let parameters : [String : AnyObject] = [
                "token": String(token) ?? "",
                "amount": amount
            ]
            
            // print(token)
            
            // for invalid character 0 be sure the content type is application/json and enconding is .JSON
            Alamofire.request(.POST, url,
                parameters: parameters,
                encoding:.JSON,
                headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            // print(json)
                            print(PKPaymentAuthorizationStatus.Success)
                            self.payButton.userInteractionEnabled = true
                            self.paymentTextField.clear()
                            self.showAlert("Payment for " + self.chargeInputView.text! + " succeeded!", color: UIColor.skyBlue(), image:UIImage(named: "ic_check_light")!)
                            self.chargeInputView.text == ""
                        }
                    case .Failure(let error):
                        print(PKPaymentAuthorizationStatus.Failure)
                        self.payButton.userInteractionEnabled = true
                        showGlobalNotification("Error paying merchant", duration: 5.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                        self.paymentTextField.clear()

                        print(error)
                    }
            }
        }
    }
    
    func payWithCard(sender: AnyObject) {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        // Card text
        paymentTextField.frame = CGRectMake(20, 260, screenWidth - 40, 60)
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 1
        paymentTextField.borderColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        paymentTextField.layer.cornerRadius = 10
        // adds a manual credit card entry textfield
        addSubviewWithBounce(paymentTextField, parentView: self, duration: 0.3)
        paymentTextField.becomeFirstResponder()
    }
    
    func getCurrentBitcoinValue(completionHandler: (value: Float) -> Void) {
        Alamofire.request(.GET, "https://blockchain.info/ticker", parameters: [:], encoding: .JSON, headers: [:])
        .validate()
        .responseJSON { (response) in
        switch response.result {
            case .Success:
                if let value = response.result.value {
                    let data = JSON(value)
                    let bitcoinUSDValue = data["USD"]["15m"].floatValue
                    // print("1 bitcoin is currently worth ")
                    // print("$", bitcoinUSDValue)
                    completionHandler(value: bitcoinUSDValue)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func payWithBitcoin(sender: AnyObject) {
        addActivityIndicatorView(UIActivityIndicatorView(), view: self.view, color: .Gray)
        
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("qrFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        self.view.endEditing(true)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(250, 300)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 10
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! BitcoinUriViewController
        // get bitcoin receiver through api call, put url in response below
        
        if chargeInputView.text != "" {
            var str = chargeInputView.text
            str?.removeAtIndex(str!.characters.indices.first!) // remove first letter

            let floatValue = (str! as NSString).floatValue*100
            
            Bitcoin.createBitcoinReceiver(Int(floatValue)) { (bitcoin, err) in
                
                    presentedViewController.bitcoinUri = bitcoin?.uri ?? ""
                    presentedViewController.bitcoinId = bitcoin?.id ?? ""
                    presentedViewController.bitcoinFilled = bitcoin?.filled ?? false
                    presentedViewController.bitcoinAmount = bitcoin?.amount ?? 0
                
                    formSheetController.willPresentContentViewControllerHandler = { vc in
                        let navigationController = vc as! UINavigationController
                        let presentedViewController = navigationController.viewControllers.first as! BitcoinUriViewController
                        presentedViewController.view?.layoutIfNeeded()
                    }
                    
                    self.presentViewController(formSheetController, animated: true, completion: nil)
                }
            }
 
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectCustomerView" {
        }
        if(segue.identifier == "mainMenuView") {
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
    
    // Add send toolbar
    func addDoneToolbar() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 60))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.dismissKeyboard(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.lightBlue()
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "DINAlternate-Bold", size: 15)!,
            NSForegroundColorAttributeName : UIColor(rgba: "#fff")
            ], forState: .Normal)
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        chargeInputView.inputAccessoryView=doneToolbar
    }
    
    func createCharge(sender: AnyObject) {
        
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func showAlert(msg: String, color: UIColor, image: UIImage) {
        let customIcon:UIImage = image // your custom icon UIImage
        let customColor:UIColor = color // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
        alertView.addAction(reset)
    }
    
    func reset() {
        // this'll run if cancel is pressed after the alert is dismissed
        paymentTextField.removeFromSuperview()
        chargeInputView.text = ""
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
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard(self)
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}