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
import Stripe
import JSSAlertView

final class AddCustomerViewController: FormViewController, UINavigationBarDelegate {
    
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
        navigationItem.title = "Invite Customer"

        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCustomerViewController.returnToMenu(_:)))
        let font = UIFont(name: "Avenir-Book", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.darkGrayColor()]
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
        
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        title = "Invite Customer"
        tableView.backgroundColor = UIColor.whiteColor()
        
        // UI
        let addCustomerButton = UIButton(frame: CGRect(x: 20, y: screenHeight-80, width: screenWidth-40, height: 60.0))
        addCustomerButton.backgroundColor = UIColor.mediumBlue()
        addCustomerButton.tintColor = UIColor(rgba: "#fff")
        addCustomerButton.setTitleColor(UIColor(rgba: "#fff"), forState: .Normal)
        addCustomerButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 16)
        addCustomerButton.setTitle("Invite Customer", forState: .Normal)
        addCustomerButton.layer.cornerRadius = 5
        addCustomerButton.layer.masksToBounds = true
        addCustomerButton.clipsToBounds = true
        addCustomerButton.addTarget(self, action: #selector(AddCustomerViewController.addCustomerButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCustomerButton)
        
        self.navigationItem.title = "Invite Customer"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let emailRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocapitalizationType = .None
            $0.textField.autocorrectionType = .No
            $0.textField.keyboardType = .EmailAddress
            }.configure {
                $0.placeholder = "Email"
                $0.rowHeight = 60
            }.onTextChanged { [weak self] in
                self?.dic["customerEmailKey"] = $0
        }

        let descriptionRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.font = UIFont(name: "Avenir-Book", size: 15)
            $0.textField.autocorrectionType = .No
            $0.textField.autocapitalizationType = .None
            }.configure {
                $0.placeholder = "Attach a note"
                $0.rowHeight = 60
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
            .set(headerViewFormer: createHeader())

        former.append(sectionFormer: titleSection)
    }
    
    func addCustomerButtonTapped(sender: AnyObject) {
        
        Customer.createCustomer(dic)
        showSuccessAlert()
    }
    
    func showSuccessAlert() {
        let customIcon:UIImage = UIImage(named: "ic_check_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor(rgba: "#1EBC61") // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: "Email invite sent to " + String(dic["customerEmailKey"]) + "!",
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }

    func returnToMenu(sender: AnyObject) {
        self.view.window!.rootViewController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dismissKeyboard()
        super.viewWillDisappear(animated)
    }
}