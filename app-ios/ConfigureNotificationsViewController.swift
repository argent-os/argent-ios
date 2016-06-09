//
//  ConfigureNotificationsViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import Former
import KeychainSwift
import PermissionScope
import CWStatusBarNotification
import Crashlytics

class ConfigureNotificationsViewController: FormViewController, UIApplicationDelegate {
    
    var dic: Dictionary<String, String> = [:]
    
    let pscope = PermissionScope()
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        Answers.logCustomEventWithName("Notifications Viewed",
                                       customAttributes: [:])
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Private
    
    private func configure() {
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        tableView.backgroundColor = UIColor.globalBackground()

        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to send real-time push notifications on account events")
        
        pscope.headerLabel.text = "App Request"
        pscope.bodyLabel.text = "Enabling push notifications"
        pscope.closeButtonTextColor = UIColor.mediumBlue()
        pscope.permissionButtonTextColor = UIColor.mediumBlue()
        pscope.permissionButtonBorderColor = UIColor.mediumBlue()
        pscope.buttonFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        pscope.labelFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        pscope.authorizedButtonColor = UIColor.brandGreen()
        pscope.unauthorizedButtonColor = UIColor.brandRed()
        pscope.permissionButtonΒorderWidth = 1
        pscope.permissionButtonCornerRadius = 5
        pscope.permissionLabelColor = UIColor.mediumBlue()
        
        self.navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        // Create RowFomers
        let pushNotificationsRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Push Notifications"
            $0.titleLabel.font = UIFont.systemFontOfSize(14)
            }.configure() { cell in
                getPushState { (val, token, error) in
                    cell.rowHeight = 60
                    cell.switched = (val?.boolValue)!
                    cell.update()
                }
            }.onSwitchChanged { on in
                switch PermissionScope().statusNotifications() {
                case .Unknown:
                    // ask
                    self.pscope.show({ finished, results in
                        print("got results \(results)")
                        // Enable push notifications
                        if #available(iOS 8.0, *) {
                            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                            UIApplication.sharedApplication().registerForRemoteNotifications()
                        } else {
                            let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
                            UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
                        }
                        }, cancelled: { (results) -> Void in
                            print("cancelled")
                    })
                case .Unauthorized, .Disabled:
                    // off
                    if(on.boolValue == false) {
                        self.updateUserNotificationRegistration(on)
                        self.deregisterPush(self)
                    } else {
                        self.pscope.show({ finished, results in
                            print(results)
                            print(finished)
                            // Enable push notifications
                            if #available(iOS 8.0, *) {
                                let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                                UIApplication.sharedApplication().registerForRemoteNotifications()
                            } else {
                                let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
                                UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
                            }
                            }, cancelled: { (results) -> Void in
                                print("cancelled")
                                print(results)
                        })
                    }
                case .Authorized:
                    // If permission is granted, post to endpoint
                    self.updateUserNotificationRegistration(true)
                }
                
                if(on.boolValue == true) {
                    showGlobalNotification("Push notifications enabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                    // show on switch changed by default
                    self.pscope.show({ finished, results in
                        print(results)
                        print(finished)
                        // Enable push notifications
                        if #available(iOS 8.0, *) {
                            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                            UIApplication.sharedApplication().registerForRemoteNotifications()
                        } else {
                            let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
                            UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
                        }
                        }, cancelled: { (results) -> Void in
                            print(results)
                    })
                } else {
                    showGlobalNotification("Push notifications disabled", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                    self.updateUserNotificationRegistration(on)
                    self.deregisterPush(self)
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
        
        let titleSection = SectionFormer(rowFormer: pushNotificationsRow).set(headerViewFormer: createHeader("Notifications"))
        former.append(sectionFormer: titleSection)
    }
    
    func deregisterPush(sender: AnyObject) {
        getPushState { (val, token, err) in
            // If the user has a device token registered in the API, allow deregistration
            if token != nil {
                showGlobalNotification("Push notifications off", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                self.updateUserNotificationRegistration(false)
            } else {
                // If a token does not exist but the push value is true (say a user delete the app but configured true to push notifications) then configure the api to deregister but without removing the token
                showGlobalNotification("Push notifications off", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.neonOrange())
                self.updateUserNotificationRegistration(false)
                // print("no device token found, cannot deregister")
            }
        }
    }
    
    func updateUserDeviceToken() {
        
        if userAccessToken != nil {

            let token = KeychainSwift().get("deviceToken")
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: AnyObject] = [ "push_state": true, "device_token" : token! ] //also works with [ "model" : NSNull()]
            let iosNSDict = iosContent as NSDictionary //no error message
        
            let parameters : [String : AnyObject] = [
                "ios" : iosNSDict
            ]
            
            let endpoint = API_URL + "/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            _ = JSON(value)
                            showGlobalNotification("Push notifications will become active on next app launch", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.skyBlue())
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func updateUserNotificationRegistration(state: Bool) {
        if userAccessToken != nil {
            
            let state = String(state.boolValue).toBool()!
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: Bool] = [ "push_state" : state ] //also works with [ "model" : NSNull()]
            let iosNSDict = iosContent as NSDictionary //no error message
            
            let parameters : [String : AnyObject] = [
                "ios" : iosNSDict
            ]
            
            let endpoint = API_URL + "/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            var data = JSON(value)
                            _ = data["ios"]["push_state"]
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func getPushState(completionHandler: (Bool?, String?, NSError?) -> ()) {
        if userAccessToken != nil {

            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let endpoint = API_URL + "/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.GET, endpoint, parameters: [:], encoding: .URL, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            var data = JSON(value)
                            var push = data["ios"]["push_state"]
                            var device_token = data["ios"]["device_token"]
                            completionHandler(push.boolValue, device_token.stringValue, nil)
                            // print(data)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
