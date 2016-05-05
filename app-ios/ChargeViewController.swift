//
//  ChargeViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import DGRunkeeperSwitch
import Stripe
import JSSAlertView
import MZFormSheetPresentationController
import QRCode

class ChargeViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var switchBal: DGRunkeeperSwitch?
    
    let chargeInputView = UITextField()

    let currencyFormatter = NSNumberFormatter()

    var currentString = ""
    
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Pay", rightTitle: "Request")

    var paymentTextField = STPPaymentCardTextField()
    
    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
        if(sender.selectedIndex == 0) {
            NSUserDefaults.standardUserDefaults().setValue("pay", forKey: "chargeType")
        }
        if(sender.selectedIndex == 1) {
            NSUserDefaults.standardUserDefaults().setValue("request", forKey: "chargeType")
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator, withString: "")
        textField.text = currencyFormatter.stringFromNumber((text as NSString).doubleValue / 100.0)
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
    
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
    
        addDoneToolbar()
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: 90, width: width, height: 50)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont(name: "Avenir-Light", size: 48)
        chargeInputView.textColor = UIColor.mediumBlue()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        chargeInputView.becomeFirstResponder()
        self.view.addSubview(chargeInputView)

        // Pay with card button
        let payWithCardButton = UIButton(frame: CGRect(x: screenWidth/2+10, y: 180, width: screenWidth/2-20-10, height: 60.0))
        payWithCardButton.backgroundColor = UIColor.clearColor()
        payWithCardButton.tintColor = UIColor.mediumBlue()
        payWithCardButton.setTitleColor(UIColor.mediumBlue(), forState: .Normal)
        payWithCardButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        payWithCardButton.layer.borderColor = UIColor.mediumBlue().CGColor
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
        payWithBitcoinButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        payWithBitcoinButton.layer.borderColor = UIColor.mediumBlue().CGColor
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

        // Transparent navigation bar
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.sendSubviewToBack(self.navigationController!.navigationBar)
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 1, width: screenWidth, height: 65))
        navBar.barTintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.lightGrayColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Book", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Argent POS");
        navBar.setItems([navItem], animated: false);
        
        // UISwitch
        runkeeperSwitch.backgroundColor = UIColor.mediumBlue()
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor.mediumBlue()
        runkeeperSwitch.titleFont = UIFont(name: "Avenir-Book", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 100.0, y: 15.0, width: view.bounds.width - 200.0, height: 30.0)
//        runkeeperSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
//        self.view.bringSubviewToFront(runkeeperSwitch)
        if(runkeeperSwitch.selectedIndex == 0) {
            NSUserDefaults.standardUserDefaults().setValue("pay", forKey: "chargeType")
        } else {
            NSUserDefaults.standardUserDefaults().setValue("request", forKey: "chargeType")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        chargeInputView.becomeFirstResponder()
//        self.navigationController?.navigationBar.addSubview(runkeeperSwitch)
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        runkeeperSwitch.removeFromSuperview()
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func payMerchant(sender: AnyObject) {
        // Function for toolbar button
        // pay merchant
        showSuccessAlert()
        chargeInputView.text = ""
        paymentTextField.clear()
    }
    
    func payWithCard(sender: AnyObject) {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        // Card text
        paymentTextField.frame = CGRectMake(20, 260, screenWidth - 40, 44)
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
//            let destination = segue.destinationViewController as! ChargeCustomerSearchController
//            destination.chargeAmount = chargeInputView.text!
//            print("charge amount is", destination.chargeAmount)
        }
    }
    
    // Add send toolbar
    func addPayMerchantToolbar()
    {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 60))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Pay Merchant", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.payMerchant(_:)))
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
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        paymentTextField.inputAccessoryView=sendToolbar
    }
    
    // Add send toolbar
    func addDoneToolbar()
    {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 60))
        // sendToolbar.barStyle = UIBarStyle.Default
        
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
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        chargeInputView.inputAccessoryView=sendToolbar
    }
    
    func createCharge(sender: AnyObject) {
        
    }
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Payment Succeeded! Amount " + chargeInputView.text!,
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
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