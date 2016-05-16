//
//  AddCustomerViewController.swift
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
import JGProgressHUD
import JSSAlertView

final class RecurringBillingViewController: FormViewController, UINavigationBarDelegate {
    
    var dic: Dictionary<String, String> = [:]
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupNav()
    }
    
    // MARK: Private
    
    private func setupNav() {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        navigationBar.tintColor = UIColor.mediumBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Add Billing Plan"
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RecurringBillingViewController.returnToMenu(_:)))
        let font = UIFont(name: "Avenir-Book", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        tableView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: screenHeight-60)
    }
    
    private func configure() {
        title = "Add Plan"

        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        tableView.frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight-60)
        tableView.backgroundColor = UIColor.whiteColor()
        
        // UI
        let addPlanButton = UIButton(frame: CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0))
        addPlanButton.backgroundColor = UIColor.mediumBlue()
        addPlanButton.tintColor = UIColor(rgba: "#fff")
        addPlanButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addPlanButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        addPlanButton.setTitle("Add Plan", forState: .Normal)
        addPlanButton.layer.cornerRadius = 5
        addPlanButton.layer.masksToBounds = true
        addPlanButton.clipsToBounds = true
        addPlanButton.addTarget(self, action: #selector(RecurringBillingViewController.addPlanButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addPlanButton)
        
        self.navigationItem.title = "Add Plan"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let planIdRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "ID"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "(i.e. gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planIdKey"] = $0
        }
        
        let planNameRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Name"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            }.configure {
                $0.placeholder = "(i.e. Gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planNameKey"] = $0
        }
        
        let planCurrencyRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Currency"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "(i.e. usd)"
                $0.rowHeight = 60                
            }.onTextChanged { [weak self] in
                self?.dic["planCurrencyKey"] = $0
        }
        
        let planAmountRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.titleLabel.text = "Amount"
            $0.titleLabel.font = UIFont.systemFontOfSize(15)
            $0.titleLabel.textColor = UIColor.grayColor()
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.keyboardType = .NumberPad
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "in $"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planAmountKey"] = $0
        }
        
        let planIntervalRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
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
                print($0.displayTitle)
                print($0.title)
                print($0.value)
                self.dic["planIntervalKey"] = $0.title
        }
        
        let planIntervalCountRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont.systemFontOfSize(15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            $0.textField.keyboardType = .NumberPad
            }.configure {
                $0.placeholder = "The number of intervals between each billing"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                if self?.dic["planIntervalKey"] == "year" && Int($0) > 1 {
                    self!.showErrorAlert()
                } else {
                    self?.dic["planIntervalCountKey"] = $0
                }
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
                $0.placeholder = "(in days)"
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
            }.configure {
                $0.placeholder = "Statement Description"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planStatementDescriptionKey"] = $0
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 0
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: planIdRow, planNameRow, planCurrencyRow, planAmountRow, planIntervalRow, planIntervalCountRow, planTrialPeriodRow, planStatementDescriptionRow)
            .set(headerViewFormer: createHeader())

        former.append(sectionFormer: titleSection)
    }
    
    func addPlanButtonTapped(sender: AnyObject) {
        print("dic is ")
        print(dic)
        Plan.createPlan(dic)
        if let msg = dic["planNameKey"] {
            showSuccessAlert(msg)
        }
    }
    
    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    func showSuccessAlert(msg: String) {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: msg + " plan created!",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    func showErrorAlert() {
        let customIcon:UIImage = UIImage(named: "ic_close_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor.brandRed() // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Interval for yearly plans can\'t be greater than 1",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}