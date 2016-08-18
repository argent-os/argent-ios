//
//  ConfigurePointOfSaleViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 5/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former
import KeychainSwift

class ConfigureAppViewController: FormViewController, UIApplicationDelegate {
    
    var dic: Dictionary<String, String> = [:]
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
    }
    
    // MARK: Private
    
    private func configure() {
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        tableView.backgroundColor = UIColor.globalBackground()
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height
        
        self.navigationItem.title = "App Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
        
        // Create RowFomers
        let configurePOSRowScreenAlive = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Keep screen alive"
            $0.titleLabel.font = UIFont(name: "SFUIText-Regular", size: 14)!
            $0.switchButton.onTintColor = UIColor.oceanBlue()
            }.configure() { cell in
                cell.rowHeight = 60
                if(KeychainSwift().getBool("screenAlive") == true) {
                    cell.switched = true
                } else {
                    cell.switched = false
                }
                cell.update()
            }.onSwitchChanged { on in
                if(on.boolValue == true) {
                    KeychainSwift().set(true, forKey: "screenAlive", withAccess: .None)
                    UIApplication.sharedApplication().idleTimerDisabled = true
                } else {
                    KeychainSwift().set(false, forKey: "screenAlive", withAccess: .None)
                    UIApplication.sharedApplication().idleTimerDisabled = false
                }
        }
        
        let configureCenterMenuRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Hide center menu text"
            $0.titleLabel.font = UIFont(name: "SFUIText-Regular", size: 14)!
            $0.switchButton.onTintColor = UIColor.oceanBlue()
            }.configure() { cell in
                cell.rowHeight = 60
                if(KeychainSwift().getBool("hideCenterMenuText") == true) {
                    cell.switched = true
                } else {
                    cell.switched = false
                }
                cell.update()
            }.onSwitchChanged { on in
                if(on.boolValue == true) {
                    KeychainSwift().set(true, forKey: "hideCenterMenuText", withAccess: .None)
                } else {
                    KeychainSwift().set(false, forKey: "hideCenterMenuText", withAccess: .None)
                }
        }
        
        // Create Headers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 0
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: configurePOSRowScreenAlive).set(headerViewFormer: createHeader("App Settings"))
        former.append(sectionFormer: titleSection)
    }
    
       //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}