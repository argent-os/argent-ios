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

class ChargeViewController: UIViewController, STPPaymentCardTextFieldDelegate, UINavigationBarDelegate {
    
    let chargeInputView = UITextField()

    let currencyFormatter = NSNumberFormatter()
    
    var paymentTextField = STPPaymentCardTextField()
    
    let notification = CWStatusBarNotification()

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
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.tintColor = UIColor.mediumBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Argent Payment Terminal"
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "AvenirNext-Regular", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightGrayColor()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func configure() {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        addDoneToolbar()
        
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: 90, width: screenWidth, height: 50)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont(name: "ArialRoundedMTBold", size: 48)
        chargeInputView.textColor = UIColor.mediumBlue()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(chargeInputView)
        
        // Pay with card button
        let payWithCardButton = UIButton(frame: CGRect(x: screenWidth/2+10, y: 180, width: screenWidth/2-20-10, height: 60.0))
        payWithCardButton.backgroundColor = UIColor.clearColor()
        payWithCardButton.tintColor = UIColor.mediumBlue()
        payWithCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        payWithCardButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14)
        payWithCardButton.layer.borderColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5).CGColor
        payWithCardButton.layer.borderWidth = 1
        payWithCardButton.layer.cornerRadius = 5
        payWithCardButton.layer.masksToBounds = true
        payWithCardButton.setTitle("Pay with Card", forState: .Normal)
        payWithCardButton.clipsToBounds = true
        payWithCardButton.addTarget(self, action: #selector(ChargeViewController.payWithCard(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payWithCardButton)
        
        // Pay with bitcoin button
        let payWithBitcoinButton = UIButton(frame: CGRect(x: 20, y: 180, width: screenWidth/2-20-10, height: 60.0))
        payWithBitcoinButton.backgroundColor = UIColor.clearColor()
        payWithBitcoinButton.tintColor = UIColor.mediumBlue()
        payWithBitcoinButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        payWithBitcoinButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14)
        payWithBitcoinButton.layer.borderColor = UIColor.mediumBlue().colorWithAlphaComponent(0.5).CGColor
        payWithBitcoinButton.layer.borderWidth = 1
        payWithBitcoinButton.layer.cornerRadius = 5
        payWithBitcoinButton.layer.masksToBounds = true
        payWithBitcoinButton.setTitle("Pay with Bitcoin", forState: .Normal)
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.clipsToBounds = true
        payWithBitcoinButton.addTarget(self, action: #selector(ChargeViewController.payWithBitcoin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payWithBitcoinButton)
        
        // Pay button
        let payButton = UIButton(frame: CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0))
        payButton.backgroundColor = UIColor.mediumBlue()
        payButton.tintColor = UIColor(rgba: "#fff")
        payButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        payButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        payButton.setTitle("Pay Merchant", forState: .Normal)
        payButton.layer.cornerRadius = 5
        payButton.layer.masksToBounds = true
        payButton.clipsToBounds = true
        payButton.addTarget(self, action: #selector(ChargeViewController.payMerchant(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(payButton)
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
    }
    
    func payMerchant(sender: AnyObject) {
        // Function for toolbar button
        // pay merchant
        showStatusNotification()
        Timeout(3.2) {
            self.showSuccessAlert()
        }
        paymentTextField.clear()
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
        paymentTextField.borderColor = UIColor.lightGrayColor()
        // adds a manual credit card entry textfield
        self.view.addSubview(paymentTextField)
    }
    
    func payWithBitcoin(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("qrFormSheetController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.contentViewSize = CGSizeMake(250, 250)
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
                print(bitcoin)
                presentedViewController.bitcoinUri = bitcoin?.uri ?? ""
                
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
    func addDoneToolbar()
    {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        _ = screen.size.height
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 60))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.dismissKeyboard(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.mediumBlue()
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Avenir-Book", size: 15.0)!,
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
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Payment for amount " + chargeInputView.text! + " succeeded!",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
        chargeInputView.text = ""
    }
    
    func showStatusNotification() {
        setupNotification()
        notification.displayNotificationWithMessage("Paying merchant " + chargeInputView.text!, forDuration: 2.5)
    }
    
    func setupNotification() {
        let inStyle = CWNotificationAnimationStyle.Top
        let outStyle = CWNotificationAnimationStyle.Top
        let notificationStyle = CWNotificationStyle.NavigationBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor.mediumBlue()
        self.notification.notificationAnimationInStyle = inStyle
        self.notification.notificationAnimationOutStyle = outStyle
        self.notification.notificationStyle = notificationStyle
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