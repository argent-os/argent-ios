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
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkBlue()
        
        showNotificationsDialog()
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
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName: UIColor.darkBlue()
        ]
        
        // Create RowFomers
        let pushNotificationsRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Push Notifications"
            $0.titleLabel.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            $0.switchButton.onTintColor = UIColor.oceanBlue()
            }.configure() { cell in
                getPushState { (val, token, error) in
                    cell.rowHeight = 60
                    cell.switched = (val?.boolValue)!
                    cell.update()
                }
            }.onSwitchChanged { state in
                self.notificationsLogic(state)
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
    
    func showNotificationsDialog() {
        self.pscope.show({ finished, results in
            print("got results \(results)")
            // Enable push notifications
            if #available(iOS 8.0, *) {
                let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                UIApplication.sharedApplication().registerForRemoteNotifications()
                Answers.logCustomEventWithName("Permission Notifications in Profile Enabled",
                    customAttributes: [:])
            } else {
                let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
                UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
                Answers.logCustomEventWithName("Permission Notifications in Profile Enabled",
                    customAttributes: [:])
            }
            }, cancelled: { (results) -> Void in
                Answers.logCustomEventWithName("Permission Notifications in Profile Cancelled",
                    customAttributes: [:])
                print("cancelled")
        })
    }
    
    func notificationsLogic(on: Bool) {
//        switch PermissionScope().statusNotifications() {
//        case .Unknown:
//            // ask
//            self.pscope.show({ finished, results in
//                print("got results \(results)")
//                // Enable push notifications
//                if #available(iOS 8.0, *) {
//                    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//                    UIApplication.sharedApplication().registerForRemoteNotifications()
//                    Answers.logCustomEventWithName("Permission Notifications in Profile Enabled",
//                        customAttributes: [:])
//                } else {
//                    let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
//                    UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
//                    Answers.logCustomEventWithName("Permission Notifications in Profile Enabled",
//                        customAttributes: [:])
//                }
//                }, cancelled: { (results) -> Void in
//                    Answers.logCustomEventWithName("Permission Notifications in Profile Cancelled",
//                        customAttributes: [:])
//                    print("cancelled")
//            })
//        case .Unauthorized, .Disabled:
//            // off
//            if(on.boolValue == false) {
//                self.updateUserNotificationRegistration(on)
//                self.deregisterPush(self)
//                Answers.logCustomEventWithName("Permission Notifications in Profile Unauthorized/Disabled",
//                                               customAttributes: [:])
//            } else {
//                self.pscope.show({ finished, results in
//                    print(results)
//                    print(finished)
//                    // Enable push notifications
//                    if #available(iOS 8.0, *) {
//                        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//                        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//                        UIApplication.sharedApplication().registerForRemoteNotifications()
//                    } else {
//                        let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
//                        UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
//                    }
//                    }, cancelled: { (results) -> Void in
//                        print("cancelled")
//                        print(results)
//                })
//            }
//        case .Authorized:
//            // If permission is granted, post to endpoint
//            Answers.logCustomEventWithName("Permission Notifications Authorized in Profile",
//                                           customAttributes: [:])
//            self.updateUserNotificationRegistration(true)
//        }
        
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
                            Answers.logCustomEventWithName("Push Notification Device Update Success",
                                customAttributes: [:])
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("Push Notification Device Update Failure",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
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
                            Answers.logCustomEventWithName("User Push Notification Update Registration Success",
                                customAttributes: [:])
                        }
                    case .Failure(let error):
                        print(error)
                        Answers.logCustomEventWithName("User Push Notification Update Registration Failure",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
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
