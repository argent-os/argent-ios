//
//  ConfigureNotificationsViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former

final class ConfigureNotificationsViewController: FormViewController {
    
    var dic: Dictionary<String, String> = [:]
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        configure()
    }
    
    // MARK: Private
    
    private func configure() {
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
        addCustomerButton.setTitle("Save", forState: .Normal)
        addCustomerButton.layer.cornerRadius = 0
        addCustomerButton.layer.masksToBounds = true
        addCustomerButton.clipsToBounds = true
        addCustomerButton.addTarget(self, action: "save:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(addCustomerButton)
        
        self.navigationItem.title = "Configure Notifications"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        
        let pushNotificationsRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Push Notifications"
            }.onSwitchChanged { on in
                print("switched")
        }
        
        let emailNotificationsRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Email Notifications"
            }.onSwitchChanged { on in
                print("switched")
        }
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 20
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: pushNotificationsRow, emailNotificationsRow)
            .set(headerViewFormer: createHeader())
        
        former.append(sectionFormer: titleSection)
    }
    
    func save(sender: AnyObject) {
        
        print("save tapped")
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}