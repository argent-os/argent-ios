//
//  PlansListDetailViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 8/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former
import CWStatusBarNotification

final class PlansListDetailViewController: FormViewController, UINavigationBarDelegate, UITextFieldDelegate {
    
    var dic: Dictionary<String, AnyObject> = [:]
    
    var planId:String?
    
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
    
    override func viewDidAppear(animated: Bool) {
        UIToolbar().tintColor = UIColor.iosBlue()
    }
    
    // toolbar buttons
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

    private func configure() {
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        UIToolbar().barTintColor = UIColor.iosBlue()
        
        tableView.backgroundColor = UIColor.globalBackground()
        tableView.contentInset.top = 60
        tableView.contentInset.bottom = 90
        tableView.contentOffset.y = 0
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let updatePlanButton = UIButton()
        updatePlanButton.frame = CGRect(x: 15, y: screenHeight-125, width: screenWidth-30, height: 50)
        updatePlanButton.setBackgroundColor(UIColor.pastelBlue(), forState: .Normal)
        updatePlanButton.setBackgroundColor(UIColor.pastelBlue().lighterColor(), forState: .Highlighted)
        updatePlanButton.tintColor = UIColor.whiteColor()
        updatePlanButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updatePlanButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        updatePlanButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)
        updatePlanButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("UPDATE PLAN", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Normal)
        updatePlanButton.layer.cornerRadius = 3
        updatePlanButton.layer.masksToBounds = true
        updatePlanButton.clipsToBounds = true
        updatePlanButton.addTarget(self, action: #selector(self.updatePlanButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let _ = Timeout(0.5) {
            addSubviewWithFade(updatePlanButton, parentView: self, duration: 0.3)
        }
        
        let deletePlanButton = UIButton()
        deletePlanButton.frame = CGRect(x: 15, y: screenHeight-65, width: screenWidth-30, height: 50)
        deletePlanButton.setBackgroundColor(UIColor.clearColor(), forState: .Normal)
        deletePlanButton.setBackgroundColor(UIColor.brandRed(), forState: .Highlighted)
        deletePlanButton.tintColor = UIColor.whiteColor()
        deletePlanButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        deletePlanButton.setTitleColor(UIColor.whiteColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        deletePlanButton.titleLabel?.font = UIFont(name: "MyriadPro-Regular", size: 16)
        deletePlanButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("DELETE PLAN", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.brandRed()), forState: .Normal)
        deletePlanButton.setAttributedTitle(adjustAttributedStringNoLineSpacing("DELETE PLAN", spacing: 1, fontName: "MyriadPro-Regular", fontSize: 14, fontColor: UIColor.whiteColor()), forState: .Highlighted)
        deletePlanButton.layer.cornerRadius = 3
        deletePlanButton.layer.masksToBounds = true
        deletePlanButton.layer.borderColor = UIColor.brandRed().CGColor
        deletePlanButton.layer.borderWidth = 1
        deletePlanButton.clipsToBounds = true
        deletePlanButton.addTarget(self, action: #selector(self.deletePlanButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let _ = Timeout(0.5) {
            addSubviewWithFade(deletePlanButton, parentView: self, duration: 0.3)
        }
        
        let statementDescriptionCharacterCountLabel = UITextField()
        statementDescriptionCharacterCountLabel.frame = CGRect(x: -20, y: 10, width: screenWidth, height: 60)
        statementDescriptionCharacterCountLabel.layer.borderWidth = 0
        statementDescriptionCharacterCountLabel.textColor = UIColor.lightBlue()
        statementDescriptionCharacterCountLabel.textAlignment = .Right
        self.view.addSubview(statementDescriptionCharacterCountLabel)
        
        Plan.getPlan(planId!) { (plan, err) in
            
            // Create RowFomers
            
            let planAmountRow = SegmentedRowFormer<FormSegmentedCell>() {

                $0.titleLabel.text = "Amount"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    let amountNum: Float = Float(plan!["amount"].stringValue)!/100
                    let nf: NSNumberFormatter = NSNumberFormatter()
                    nf.numberStyle = NSNumberFormatterStyle.CurrencyStyle
                    let convertedString: String = nf.stringFromNumber(amountNum)!
                    $0.segmentTitles = [convertedString]
                    $0.rowHeight = 60
                    $0.cell.tintColor = UIColor.pastelBlue()
                    $0.selectedIndex = 0
                    self.dic["amount"] = plan!["amount"].stringValue

            }
            
            let planNameRow = SegmentedRowFormer<FormSegmentedCell>() {
                $0.titleLabel.text = "Name"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    $0.segmentTitles = [plan!["name"].stringValue]
                    $0.rowHeight = 60
                    $0.selectedIndex = 0
                    $0.cell.tintColor = UIColor.pastelBlue()
                }
            
            
            let planCurrencyRow = SegmentedRowFormer<FormSegmentedCell>() {
                $0.titleLabel.text = "Currency"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    $0.segmentTitles = ["USD"]
                    self.dic["currency"] = plan!["currency"].stringValue
                    $0.rowHeight = 60
                    $0.cell.tintColor = UIColor.pastelBlue()
                    $0.selectedIndex = 0
            }
        
            let planIntervalRow = SegmentedRowFormer<FormSegmentedCell>() {
                $0.titleLabel.text = "Interval"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    $0.segmentTitles = [plan!["interval"].stringValue]
                    self.dic["interval"] = plan!["interval"].stringValue
                    $0.rowHeight = 60
                    $0.cell.tintColor = UIColor.pastelBlue()
                    $0.selectedIndex = 0
            }
            
            let planTrialPeriodRow = SegmentedRowFormer<FormSegmentedCell>() {
                $0.titleLabel.text = "Trial"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    if plan!["trial_period_days"].stringValue == "" {
                        $0.segmentTitles = ["0 days"]
                    } else {
                        $0.segmentTitles = [plan!["trial_period_days"].stringValue + " days"]
                    }
                    $0.rowHeight = 60
                    $0.cell.tintColor = UIColor.pastelBlue()
                    $0.selectedIndex = 0
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
                    if plan!["statement_descriptor"].stringValue == "" {
                        $0.placeholder = "(22 characters) Statement Descriptor"
                    } else {
                        $0.placeholder = plan!["statement_descriptor"].stringValue
                    }
                    $0.rowHeight = 60
                    self.dic["statement_descriptor"] = $0.text ?? ""
                }.onTextChanged { [weak self] in
                    self?.dic["statement_descriptor"] = $0 ?? ""
                    statementDescriptionCharacterCountLabel.text = String($0.characters.count) + "/22"
                    if $0.characters.count > 22 {
                        statementDescriptionCharacterCountLabel.textColor = UIColor.brandRed()
                    } else {
                        statementDescriptionCharacterCountLabel.textColor = UIColor.lightBlue()
                    }
            }
            
            let planIntervalCountRow = SegmentedRowFormer<FormSegmentedCell>() {
                $0.titleLabel.text = "Interval"
                $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 15)!
                $0.titleLabel.textColor = UIColor.mediumBlue()
                }.configure {
                    $0.segmentTitles = [plan!["interval_count"].stringValue]
                    self.dic["interval_count"] = plan!["interval_count"].stringValue
                    $0.rowHeight = 60
                    $0.cell.tintColor = UIColor.pastelBlue()
                    $0.selectedIndex = 0
                }.onSegmentSelected { (segment, str) in
                    self.dic["interval_count"] = str.lowercaseString
            }
            
            // Create Headers
            
            let createHeader: (() -> ViewFormer) = {
                return CustomViewFormer<FormHeaderFooterView>()
                    .configure {
                        $0.viewHeight = 0
                }
            }
            
            // Create SectionFormers
            
            let titleSection = SectionFormer(rowFormer: planAmountRow, planNameRow, planCurrencyRow, planIntervalRow, planIntervalCountRow, planTrialPeriodRow, planStatementDescriptionRow)
                .set(headerViewFormer: createHeader())
            
            self.former.append(sectionFormer: titleSection)
                .onCellSelected { [weak self] _ in
                    self?.formerInputAccessoryView.update()
            }
            
        }
    }
    
    func deletePlanButtonTapped(sender: AnyObject) {
        if let id = planId {
            let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                Plan.deletePlan(id, completionHandler: { (bool, err) in
                    if bool == true {
                        self.dismissViewControllerAnimated(true, completion: {
                            showGlobalNotification("Plan deleted, pull down to refresh.", duration: 4.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                        })
                    } else {
                        showAlert(.Error, title: "Error", msg: "Error deleting plan")
                    }
                })
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func updatePlanButtonTapped(sender: AnyObject) {
        Plan.updatePlan(planId!, dic: dic) { (bool, err) in
            if bool == true {
                showAlert(.Success, title: "Success", msg: "Plan updated")
            } else {
                showAlert(.Error, title: "Error", msg: (err?.localizedDescription)!)
            }
        }
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
    
    func endEditing(sender: AnyObject) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}