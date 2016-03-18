//
//  AddCustomerViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 3/15/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former
import SVProgressHUD

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
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // UI
        let addPlanButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.91, width: screenWidth, height: 60.0))
        addPlanButton.backgroundColor = UIColor(rgba: "#1796fa")
        addPlanButton.tintColor = UIColor(rgba: "#fff")
        addPlanButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addPlanButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        addPlanButton.setTitle("Add Plan", forState: .Normal)
        addPlanButton.layer.cornerRadius = 0
        addPlanButton.layer.masksToBounds = true
        addPlanButton.clipsToBounds = true
        addPlanButton.addTarget(self, action: "addPlanButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addPlanButton)
        
        self.navigationItem.title = "Add Plan"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let planIdRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Plan ID (e.g. gold)"
            }.onTextChanged { [weak self] in
                self?.dic["planIdKey"] = $0
        }
        
        let planNameRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Plan Name (e.g. Gold)"
            }.onTextChanged { [weak self] in
                self?.dic["planNameKey"] = $0
        }
        
        let planCurrencyRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Currency"
            }.onTextChanged { [weak self] in
                self?.dic["planCurrencyKey"] = $0
        }
        
        let planAmountRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Amount"
            }.onTextChanged { [weak self] in
                self?.dic["planAmountKey"] = $0
        }
        
        let planIntervalRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Interval"
            }.onTextChanged { [weak self] in
                self?.dic["planIntervalKey"] = $0
        }
        
        let planTrialPeriodRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Trial Period"
            }.onTextChanged { [weak self] in
                self?.dic["planTrialPeriodKey"] = $0
        }
        
        let planStatementDescriptionRow = TextFieldRowFormer<FormTextFieldCell>() {
            //            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Statement Description"
            }.onTextChanged { [weak self] in
                self?.dic["planStatementDescriptionKey"] = $0
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 20
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: planIdRow, planNameRow, planCurrencyRow, planAmountRow, planIntervalRow, planTrialPeriodRow, planStatementDescriptionRow)
            .set(headerViewFormer: createHeader())
        
        former.append(sectionFormer: titleSection)
    }
    
    func addPlanButtonTapped(sender: AnyObject) {
        
        SVProgressHUD.show()
        
        print("add plan tapped")
        // Post plan using Alamofire
        let plan_id = dic["planIdKey"]
        let plan_name = dic["planNameKey"]
        let plan_currency = dic["planCurrencyKey"]
        let plan_amount = dic["planAmountKey"]
        let plan_interval = dic["planIntervalKey"]
        let plan_trial_period = dic["planTrialPeriodKey"]
        let plan_statement_desc = dic["planStatementDescriptionKey"]
        
        print("plan id is", plan_id)
        let stripeKey = userData!["user"]["stripe"]["secretKey"].stringValue
        
        let headers = [
            "Authorization": "Bearer " + stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : [String : AnyObject] = [
            "id": plan_id!,
            "amount": plan_amount!,
            "interval": plan_interval!,
            "name": plan_name!,
            "currency": plan_currency!
        ]
        
        Alamofire.request(.POST, stripeApiUrl + "/v1/plans",
            parameters: parameters,
            encoding:.URL,
            headers: headers)
            .responseJSON { response in
                print(response.request) // original URL request
                print(response.response?.statusCode) // URL response
                print(response.data) // server data
                print(response.result) // result of response serialization
                
                // go to main view
                if(response.response?.statusCode == 200) {
                    print("green light")
                } else {
                    print("red light")
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        SVProgressHUD.showSuccessWithStatus("Plan added!")
                        let json = JSON(value)
                        print(json)
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    SVProgressHUD.showErrorWithStatus("Error adding plan")
                    print(error)
                }
        }
        
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}