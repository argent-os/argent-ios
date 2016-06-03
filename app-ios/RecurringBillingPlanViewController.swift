//
//  RecurringBillingViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former
import JSSAlertView

final class RecurringBillingViewController: FormViewController, UINavigationBarDelegate, UITextFieldDelegate {
    
    var dic: Dictionary<String, String> = [:]
    
    let amountInputView = UITextField()

    let perIntervalLabel = UILabel()

    let currencyFormatter = NSNumberFormatter()

    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    // MARK: Private
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 60)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.mediumBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = ""
        navigationItem.titleView?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.mediumBlue()]

        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.returnToMenu(_:)))
        let font = UIFont.systemFontOfSize(14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName:UIColor.mediumBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        addSubviewWithFade(navigationBar, parentView: self, duration: 0.5)
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    private func generatePlanID(plan: String, len: Int) -> Void {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        let editedPlanString = plan.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let convertedPlanString = String(editedPlanString).lowercaseString + "_" + (randomString as String)
        self.dic["planIdKey"] = convertedPlanString
        print(convertedPlanString)
    }
    
    private func configure() {

        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        tableView.backgroundColor = UIColor.globalBackground()
        tableView.contentInset.top = 160
        tableView.contentInset.bottom = 90
        tableView.contentOffset.y = 0
        tableView.frame = CGRect(x: 0, y: 350, width: screenWidth, height: screenHeight)
        
        // UI
        let addPlanButton = UIButton(frame: CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0))
        addPlanButton.setBackgroundColor(UIColor.lightBlue(), forState: .Normal)
        addPlanButton.setBackgroundColor(UIColor.lightBlue().colorWithAlphaComponent(0.75), forState: .Highlighted)
        addPlanButton.tintColor = UIColor(rgba: "#fff")
        addPlanButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addPlanButton.setTitleColor(UIColor(rgba: "#fffe"), forState: .Highlighted)
        addPlanButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 16)
        addPlanButton.setTitle("Add Plan", forState: .Normal)
        addPlanButton.layer.cornerRadius = 5
        addPlanButton.layer.masksToBounds = true
        addPlanButton.clipsToBounds = true
        addPlanButton.addTarget(self, action: #selector(RecurringBillingViewController.addPlanButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        Timeout(0.5) {
            addSubviewWithFade(addPlanButton, parentView: self, duration: 0.3)
        }

        amountInputView.addTarget(self, action: #selector(self.endEditing(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        amountInputView.addTarget(self, action: #selector(self.textField(_:shouldChangeCharactersInRange:replacementString:)), forControlEvents: UIControlEvents.EditingChanged)
        amountInputView.delegate = self
        amountInputView.frame = CGRect(x: 0, y: -10, width: screenWidth, height: 170)
        amountInputView.textAlignment = .Center
        amountInputView.font = UIFont(name: "DINAlternate-Bold", size: 48)
        amountInputView.textColor = UIColor.lightBlue()
        amountInputView.placeholder = "$0.00"
        amountInputView.keyboardType = UIKeyboardType.NumberPad
        amountInputView.backgroundColor = UIColor.offWhite()
        amountInputView.tintColor = UIColor.lightBlue()
        amountInputView.becomeFirstResponder()
        self.view.addSubview(amountInputView)
        
        let topImageView = UIImageView()
        topImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        topImageView.image = UIImage(named: "BackgroundGradientFuschia")
        topImageView.contentMode = .ScaleAspectFill
//        addSubviewWithBounce(topImageView, parentView: self)
//        self.view.sendSubviewToBack(topImageView)
        
        perIntervalLabel.frame = CGRect(x: 0, y: 110, width: screenWidth, height: 50)
        perIntervalLabel.textAlignment = .Center
        perIntervalLabel.font = UIFont(name: "DINAlternate-Bold", size: 16)
        perIntervalLabel.textColor = UIColor.lightBlue()
        perIntervalLabel.text = ""
        perIntervalLabel.backgroundColor = UIColor.clearColor()
        addSubviewWithBounce(self.perIntervalLabel, parentView: self, duration: 0.3)
        
        // Create RowFomers
        
        let planNameRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Name"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            }.configure {
                $0.placeholder = "Name of the plan (i.e. Gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planNameKey"] = $0
                self!.generatePlanID($0, len: 16)
        }
        
        let planCurrencyRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Currency"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            }.configure {
                let currencies = ["", "usd"]
                $0.rowHeight = 60
                $0.pickerItems = currencies.map {
                    InlinePickerItem(title: $0)
                }
                if let currencyAmount = Plan.sharedInstance.currency {
                    $0.selectedRow = currencies.indexOf(currencyAmount) ?? 0
                }
            }.onValueChanged {
                self.dic["planCurrencyKey"] = $0.title
        }
        
        let planIntervalRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
            $0.titleLabel.text = "Interval"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            }.configure {
                let intervals = ["", "day", "week", "month", "year"]
                $0.rowHeight = 60
                $0.pickerItems = intervals.map {
                    InlinePickerItem(title: $0)
                }
                if let invervalAmount = Plan.sharedInstance.interval {
                    $0.selectedRow = intervals.indexOf(invervalAmount) ?? 0
                }
            }.onValueChanged {
                self.perIntervalLabel.text = "per " + $0.title
                self.dic["planIntervalKey"] = $0.title
        }
        
        let planTrialPeriodRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Trial"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.keyboardType = .NumberPad
            }.configure {
                $0.placeholder = "(Optional) in days"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planTrialPeriodKey"] = $0
        }
        
        let planStatementDescriptionRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Desc"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = .systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.returnKeyType = .Done
            }.configure {
                $0.placeholder = "(Optional) Statement Description"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planStatementDescriptionKey"] = $0
        }
        
        let planIntervalCountRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Cycle"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.keyboardType = .NumberPad
            }.configure {
                $0.placeholder = "e.g. count=3 with interval=day bills every 3 days"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                if self?.dic["planIntervalKey"] == "year" && Int($0) > 1 {
                    self!.showAlert("Interval for yearly plans cannot be greater than 1", color: UIColor.brandRed(), icon: "ic_close_light")
                } else {
                    self?.dic["planIntervalCountKey"] = $0
                }
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 0
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: planNameRow, planCurrencyRow, planIntervalRow, planIntervalCountRow, planTrialPeriodRow, planStatementDescriptionRow)
            .set(headerViewFormer: createHeader())

        former.append(sectionFormer: titleSection)
    }
    
    func addPlanButtonTapped(sender: AnyObject) {
        Plan.createPlan(dic) { (bool, err) in
            if bool == true {
                if let msg = self.dic["planNameKey"] {
                    self.showAlert(msg + " plan created!", color: UIColor.brandGreen(), icon: "ic_check_light")
                    self.amountInputView.text = ""
                    self.perIntervalLabel.text = ""
                }
            } else {
                self.showAlert(err, color: UIColor.brandRed(), icon: "ic_close_light")
            }
        }
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func showAlert(msg: String, color: UIColor, icon: String) {
        let customIcon:UIImage = UIImage(named: icon)! // your custom icon UIImage
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg,
            buttonText: "Close",
            noButtons: false,
            color: color,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Construct the text that will be in the field if this change is accepted
        let oldText = amountInputView.text! as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString!
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
        formatter.locale = NSLocale.currentLocale()
        let numberFromField = (NSString(string: digitText).doubleValue)/100
        newText = formatter.stringFromNumber(numberFromField)
        
        textField.text = String(newText)
        
        // revert for posting string to api
        var originalString = textField.text
        originalString?.removeAtIndex(originalString!.characters.indices.first!) // remove first letter
        let revertString = originalString?.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let revertString2 = revertString?.stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.dic["planAmountKey"] = revertString2
        
        return false
    }
    
    func endEditing(sender: AnyObject) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}