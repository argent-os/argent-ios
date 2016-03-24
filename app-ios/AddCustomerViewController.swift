//
//  AddCustomerViewController.swift
//  protonpay-ios
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
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // UI
        let addCustomerButton = UIButton(frame: CGRect(x: 0, y: screenHeight*0.91, width: screenWidth, height: 60.0))
        addCustomerButton.backgroundColor = UIColor(rgba: "#1796fa")
        addCustomerButton.tintColor = UIColor(rgba: "#fff")
        addCustomerButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addCustomerButton.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 16)
        addCustomerButton.setTitle("Add Customer", forState: .Normal)
        addCustomerButton.layer.cornerRadius = 0
        addCustomerButton.layer.masksToBounds = true
        addCustomerButton.clipsToBounds = true
        addCustomerButton.addTarget(self, action: "addCustomerButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCustomerButton)
        
        self.navigationItem.title = "Add Customer"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let emailRow = TextFieldRowFormer<FormTextFieldCell>() {
//            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFontOfSize(15)
            $0.textField.autocapitalizationType = .None
            $0.textField.autocorrectionType = .No
            $0.textField.keyboardType = .EmailAddress
            }.configure {
                $0.placeholder = "Customer email"
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
                    $0.viewHeight = 20
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: emailRow, descriptionRow)
            .set(headerViewFormer: createHeader())
        
        former.append(sectionFormer: titleSection)
    }
    
    func addCustomerButtonTapped(sender: AnyObject) {
        
        SVProgressHUD.show()
        
        print(dic)
        
        print("add customer tapped")
        // Post plan using Alamofire
        let cust_email = dic["customerEmailKey"]
        let cust_desc = dic["customerDescriptionKey"]
        
        let stripeKey = userData!["user"]["stripe"]["secretKey"].stringValue
        
        print("stripe key is", stripeKey)
        let headers = [
            "Authorization": "Bearer " + stripeKey,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : [String : AnyObject] = [
            "email": cust_email!,
            "description": cust_desc! ?? "",
        ]
        
        Alamofire.request(.POST, stripeApiUrl + "/v1/customers",
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
                        SVProgressHUD.showSuccessWithStatus("Customer Added!")
                        let json = JSON(value)
                        print(json)
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    SVProgressHUD.showErrorWithStatus("Error Adding Customer")
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