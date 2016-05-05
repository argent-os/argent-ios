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

final class RecurringBillingViewController: FormViewController {
    
    var dic: Dictionary<String, String> = [:]
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        title = "Add Customer"
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        tableView.backgroundColor = UIColor.whiteColor()

        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
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
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "Plan ID (i.e. gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planIdKey"] = $0
        }
        
        let planNameRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .Words
            }.configure {
                $0.placeholder = "Plan Name (i.e. Gold)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planNameKey"] = $0
        }
        
        let planCurrencyRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "Currency"
                $0.rowHeight = 60                
            }.onTextChanged { [weak self] in
                self?.dic["planCurrencyKey"] = $0
        }
        
        let planAmountRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "Amount"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planAmountKey"] = $0
        }
        
        let planIntervalRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Interval"
            $0.titleLabel.textColor = UIColor.lightGrayColor()
            }.configure {
                let intervals = ["day", "month", "week", "year"]
                $0.rowHeight = 60
                $0.pickerItems = intervals.map {
                    InlinePickerItem(title: $0)
                }
                if let invervalAmount = Plan.sharedInstance.interval {
                    $0.selectedRow = intervals.indexOf(invervalAmount) ?? 0
                }
            }.onValueChanged {
                self.dic["planIntervalKey"] = $0.title
        }
        
        let planTrialPeriodRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "Trial Period (in days)"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["planTrialPeriodKey"] = $0
        }
        
        let planStatementDescriptionRow = TextFieldRowFormer<FormTextFieldCell>() {
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
        
        let titleSection = SectionFormer(rowFormer: planIdRow, planNameRow, planCurrencyRow, planAmountRow, planIntervalRow, planTrialPeriodRow, planStatementDescriptionRow)
        
        former.append(sectionFormer: titleSection)
    }
    
    func addPlanButtonTapped(sender: AnyObject) {
        Plan.createPlan(dic)
        showSuccessAlert()
    }
    
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Plan " + String(dic["planNameKey"]) + " created!",
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