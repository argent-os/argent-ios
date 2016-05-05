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
    
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: height*0.20, width: width, height: 50)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = UIFont(name: "Avenir-Light", size: 48)
        chargeInputView.textColor = UIColor.mediumBlue()
        chargeInputView.placeholder = "$0.00"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        chargeInputView.becomeFirstResponder()
        self.view.addSubview(chargeInputView)
        
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
        
        // Card text
        paymentTextField.frame = CGRectMake(20, height*0.40, screenWidth - 40, 44)
        paymentTextField.delegate = self
        paymentTextField.borderWidth = 1
        paymentTextField.borderColor = UIColor.lightGrayColor()
        // adds a manual credit card entry textfield
        self.view.addSubview(paymentTextField)
        
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
    
    func createCharge(sender: AnyObject) {
        
    }
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_close_light")! // your custom icon UIImage
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
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        paymentTextField.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard()
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}