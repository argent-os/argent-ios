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
import JGProgressHUD
import UIKit
import Former

final class AddCustomerViewController: FormViewController {
    
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
        let addCustomerButton = UIButton(frame: CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0))
        addCustomerButton.backgroundColor = UIColor.mediumBlue()
        addCustomerButton.tintColor = UIColor(rgba: "#fff")
        addCustomerButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addCustomerButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        addCustomerButton.setTitle("Add Customer", forState: .Normal)
        addCustomerButton.layer.cornerRadius = 5
        addCustomerButton.layer.masksToBounds = true
        addCustomerButton.clipsToBounds = true
        addCustomerButton.addTarget(self, action: #selector(AddCustomerViewController.addCustomerButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCustomerButton)
        
        self.navigationItem.title = "Add Customer"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let emailRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = .systemFontOfSize(15)
            $0.textField.autocapitalizationType = .None
            $0.textField.autocorrectionType = .No
            $0.textField.keyboardType = .EmailAddress
            }.configure {
                $0.placeholder = "Customer Email"
            }.onTextChanged { [weak self] in
                self?.dic["customerEmailKey"] = $0
        }


        let descriptionRow = TextViewRowFormer<FormTextViewCell>() {
            $0.textView.font = .systemFontOfSize(15)
            }.configure {
                $0.placeholder = "Customer Description"
                $0.rowHeight = 150
            }.onTextChanged { [weak self] in
                self?.dic["customerDescriptionKey"] = $0
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 0
            }
        }
        
        // Create SectionFormers
        
        // TODO: Add paymentRow using Stripe payment textfield adding to view
        
        let titleSection = SectionFormer(rowFormer: emailRow, descriptionRow)
        
        former.append(sectionFormer: titleSection)
    }
    
    func addCustomerButtonTapped(sender: AnyObject) {
        
        Customer.createCustomer(dic)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}