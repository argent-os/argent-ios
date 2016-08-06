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
import TRCurrencyTextField

final class RecurringBillingViewController: FormViewController, UINavigationBarDelegate, UITextFieldDelegate {
    
    var dic: Dictionary<String, AnyObject> = [:]
    
    let amountInputView = UITextField()

    let perIntervalLabel = UILabel()

    let currencyFormatter = NSNumberFormatter()

    let amountCurrencyField = TRCurrencyTextField()

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
        navigationItem.titleView?.tintColor = UIColor.mediumBlue()
        self.navigationController?.navigationItem.title = "Create a Billing Plan"
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        self.dic["id"] = convertedPlanString
        print(convertedPlanString)
    }
    
    override func viewDidAppear(animated: Bool) {
        UIToolbar().tintColor = UIColor.iosBlue()
    }
    
    // toolbar buttons
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    func currencyTextFieldDidChange(textField: TRCurrencyTextField) {
        // e.g. 1234.44 becomes 123444.00 -> 123444
        self.dic["amount"] = Int(Float(amountCurrencyField.value)*100)
    }
    
    private func configure() {

        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        UIToolbar().barTintColor = UIColor.iosBlue()
        
        tableView.backgroundColor = UIColor.globalBackground()
        tableView.contentInset.top = 120
        tableView.contentInset.bottom = 90
        tableView.contentOffset.y = 0
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let maskView = UIView()
        maskView.backgroundColor = UIColor.whiteColor()
        maskView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 115)
        self.view.addSubview(maskView)
        
        let addPlanButton = UIButton(frame: CGRect(x: 0, y: screenHeight-60, width: screenWidth, height: 60.0))
        addPlanButton.setBackgroundColor(UIColor.oceanBlue(), forState: .Normal)
        addPlanButton.setBackgroundColor(UIColor.oceanBlue().lighterColor(), forState: .Highlighted)
        addPlanButton.tintColor = UIColor(rgba: "#fff")
        addPlanButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addPlanButton.setTitleColor(UIColor(rgba: "#fffe"), forState: .Highlighted)
        addPlanButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)
        addPlanButton.setTitle("Create Plan", forState: .Normal)
        addPlanButton.layer.cornerRadius = 0
        addPlanButton.layer.masksToBounds = true
        addPlanButton.clipsToBounds = true
        addPlanButton.addTarget(self, action: #selector(RecurringBillingViewController.addPlanButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let _ = Timeout(0.5) {
            addSubviewWithFade(addPlanButton, parentView: self, duration: 0.3)
        }

        let amountLabel = UILabel()
        amountLabel.text = "Amount"
        amountLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
        amountLabel.textColor = UIColor.darkBlue()
        amountLabel.frame = CGRect(x: 15, y: 60, width: 200, height: 60)
        self.view.addSubview(amountLabel)
        self.view.bringSubviewToFront(amountLabel)
        
        amountCurrencyField.placeholder = "Amount of the Billing Plan"
        amountCurrencyField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
        amountCurrencyField.textColor = UIColor.darkBlue()
        amountCurrencyField.frame = CGRect(x: 115, y: 60, width: 300, height: 60)
        let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
        amountCurrencyField.setCountryCode(countryCode)
        amountCurrencyField.setLocale(NSLocale.currentLocale())
        amountCurrencyField.addWhiteSpaceOnSymbol = false
        amountCurrencyField.maxDigits = 6
        amountCurrencyField.borderStyle = .None
        amountCurrencyField.addTarget(self, action: #selector(self.currencyTextFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.view.addSubview(amountCurrencyField)
        self.view.bringSubviewToFront(amountCurrencyField)
        
        // Create RowFomers
        
//        var planAmountValue = 0
//        let planAmountRow = TextFieldRowFormer<AmountInputCell>(instantiateType: .Nib(nibName: "AmountInputCell")) { [weak self] in
//            $0.titleLabel.text = "Amount"
//            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
//            $0.titleLabel.textColor = UIColor.mediumBlue()
//
//            $0.regularTextField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
//            $0.regularTextField.autocorrectionType = .No
//            $0.regularTextField.autocapitalizationType = .Words
//            $0.regularTextField.keyboardType = .NumberPad
//            $0.regularTextField.inputAccessoryView = self?.formerInputAccessoryView
//            }.configure {
//                $0.placeholder = "Amount of the billing plan (e.g. 100)"
//                $0.rowHeight = 60
//            }.onTextChanged { [weak self] in
//                self?.dic["amount"] = $0
//        }
//        
        let planNameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            $0.textField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Name of the plan (e.g. Gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["name"] = $0
                self!.generatePlanID($0, len: 16)
        }
        
//        let planCurrencyRow = InlinePickerRowFormer<CustomLabelCell, String>(instantiateType: .Nib(nibName: "CustomLabelCell")) {
//            $0.titleLabel.text = "Currency"
//            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
//            $0.titleLabel.textColor = UIColor.mediumBlue()
//            }.configure {
//                let currencies = ["", "USD"]
//                $0.rowHeight = 60
//                $0.pickerItems = currencies.map {
//                    InlinePickerItem(title: $0)
//                }
//                if let currencyType = Plan.sharedInstance.currency {
//                    $0.selectedRow = currencies.indexOf(currencyType) ?? 0
//                }
//            }.onValueChanged {
//                self.dic["currency"] = $0.title.lowercaseString
//        }
        
        let planCurrencyRow = SegmentedRowFormer<FormSegmentedCell>() {
            $0.titleLabel.text = "Currency"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            }.configure {
                $0.segmentTitles = ["USD"]
                $0.rowHeight = 60
                $0.cell.tintColor = UIColor.oceanBlue()
                $0.selectedIndex = 0
                self.dic["currency"] = $0.segmentTitles[$0.selectedIndex]
            }.onSegmentSelected { (segment, str) in
                self.dic["currency"] = str.lowercaseString
        }
        
        let planIntervalRow = SegmentedRowFormer<FormSegmentedCell>() {
            $0.titleLabel.text = "Interval"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            }.configure {
                $0.segmentTitles = ["Day", "Week", "Month", "Year"]
                $0.rowHeight = 60
                $0.cell.tintColor = UIColor.oceanBlue()
                $0.selectedIndex = UISegmentedControlNoSegment
        }.onSegmentSelected { (segment, str) in
                self.dic["interval"] = str.lowercaseString
        }
        
        let planTrialPeriodRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Trial"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            $0.textField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "(Optional) Trial period in days"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["trial_period_days"] = $0
        }
        
        let planStatementDescriptionRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Desc"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            $0.textField.font = .systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.returnKeyType = .Done
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "(Optional) Statement descriptor"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["statement_descriptor"] = $0
        }
        
        let planIntervalCountRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Count"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.titleLabel.textColor = UIColor.mediumBlue()
            $0.textField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
            $0.textField.text = "1"
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.keyboardType = .NumberPad
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "e.g. '1' and 'month' bills once a month"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["interval_count"] = Int($0)
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
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }
    
    func addPlanButtonTapped(sender: AnyObject) {
        Plan.createPlan(dic) { (bool, err) in
            if bool == true {
                if let msg = self.dic["name"] {
                    showAlert(.Success, title: "Success", msg: (msg as! String) + " plan created!")
                    self.amountInputView.text = ""
                    self.perIntervalLabel.text = ""
                }
            } else {
                showAlert(.Error, title: "Error", msg: err)
            }
        }
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func endEditing(sender: AnyObject) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}