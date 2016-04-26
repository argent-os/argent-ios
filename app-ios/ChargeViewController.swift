//
//  ChargeViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/3/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import VENCalculatorInputView
import DGRunkeeperSwitch

class ChargeViewController: UIViewController, VENCalculatorInputViewDelegate {
    
    @IBOutlet weak var switchBal: DGRunkeeperSwitch?
    
    let chargeInputView = UITextField()

    let currencyFormatter = NSNumberFormatter()

    var currentString = ""
    
    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
        if(sender.selectedIndex == 0) {
            NSUserDefaults.standardUserDefaults().setValue("pay", forKey: "chargeType")
            print("pay selected")
        }
        if(sender.selectedIndex == 1) {
            NSUserDefaults.standardUserDefaults().setValue("request", forKey: "chargeType")
            print("request selected")
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        let text = textField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator, withString: "")
        textField.text = currencyFormatter.stringFromNumber((text as NSString).doubleValue / 100.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addChargeToolbarButton()
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
    
        chargeInputView.addTarget(self, action: #selector(ChargeViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        chargeInputView.frame = CGRect(x: 0, y: height*0.28, width: width, height: 80)
        chargeInputView.textAlignment = .Center
        chargeInputView.font = chargeInputView.font!.fontWithSize(36)
        chargeInputView.textColor = UIColor(rgba: "#1EBC61")
        chargeInputView.placeholder = "Enter Amount"
        chargeInputView.keyboardType = UIKeyboardType.NumberPad
        chargeInputView.backgroundColor = UIColor.clearColor()
        chargeInputView.becomeFirstResponder()
        self.view.addSubview(chargeInputView)
        
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, width, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.nextStep(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor(rgba: "#157efb")
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
        
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)

        // Transparent navigation bar
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.hidden = true
        self.navigationController!.navigationBar.sendSubviewToBack(self.navigationController!.navigationBar)
        
        // UISwitch
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Pay", rightTitle: "Request")
        runkeeperSwitch.backgroundColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.titleFont = UIFont(name: "Avenir-Book", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 50.0, y: 28.0, width: view.bounds.width - 100.0, height: 30.0)
//        runkeeperSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
        self.view.addSubview(runkeeperSwitch)
        self.view.bringSubviewToFront(runkeeperSwitch)
        if(runkeeperSwitch.selectedIndex == 0) {
            NSUserDefaults.standardUserDefaults().setValue("pay", forKey: "chargeType")
        } else {
            NSUserDefaults.standardUserDefaults().setValue("request", forKey: "chargeType")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        chargeInputView.becomeFirstResponder()
        super.viewDidAppear(true)
    }
    
    func calculatorInputView(inputView: VENCalculatorInputView, didTapKey key: String) {
        print("Just tapped key: %@", key)
        // Handle the input. Something like [myTextField insertText:key];
    }

    func calculatorInputViewDidTapBackspace(calculatorInputView: VENCalculatorInputView) {
        print("Just tapped backspace.")
        // Handle the backspace. Something like [myTextField deleteBackward];
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func nextStep(sender: AnyObject) {
        // Function for toolbar button
        self.performSegueWithIdentifier("selectCustomerView", sender: sender)
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
    func addChargeToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Create Charge", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ChargeViewController.createCharge(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor(rgba: "#157efb")
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
    }
    
    func createCharge(sender: AnyObject) {
        
    }
    
    //Textfield delegates
    func textField(textField: VENCalculatorInputTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("executing")
        // Construct the text that will be in the field if this change is accepted
        let oldText = textField.text! as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        var newTextString = String(newText)
        
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var digitText = ""
        for c in newTextString.unicodeScalars {
            if digits.longCharacterIsMember(c.value) {
                digitText.append(c)
            }
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        let numberFromField = Double(digitText)!/100
        newText = formatter.stringFromNumber(numberFromField)!
        
        print(newText)
        textField.text = newText
        
        return false
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard()
        self.navigationController!.navigationBar.hidden = false
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}