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
import KeychainSwift
import JGProgressHUD

class ConfigureNotificationsViewController: FormViewController, UIApplicationDelegate {
    
    var dic: Dictionary<String, String> = [:]
    
    // MARK: Public
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: Private
    
    private func configure() {
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        tableView.backgroundColor = UIColor.whiteColor()
        // screen width and height:
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        _ = screen.size.height

        self.navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        // Create RowFomers
        let pushNotificationsRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Push Notifications"
            }.configure() { cell in
                getPushState { (val, token, error) in
                    cell.switched = (val?.boolValue)!
                    cell.update()
                }
            }.onSwitchChanged { on in
                if(on.boolValue == true) {
                    print("updating value to ", on)
                    self.updateUserNotificationRegistration(true)
                    self.promptUserToRegisterPushNotifications(self)
                } else {
                    print("updating value to ", on)
                    self.updateUserNotificationRegistration(on)
                    self.deregisterPush(self)
                }
                print("switched")
        }
        
        // Create Headers
        
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        let titleSection = SectionFormer(rowFormer: pushNotificationsRow).set(headerViewFormer: createHeader("Notifications"))
        former.append(sectionFormer: titleSection)
    }
    
    func deregisterPush(sender: AnyObject) {
        print("deregistering push")
        getPushState { (val, token, err) in
            // If the user has a device token registered in the API, allow deregistration
            if token != nil {
                let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
                HUD.showInView(self.view!)
                HUD.textLabel.text = "Push Notifications are Off"
                HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                HUD.position = JGProgressHUDPosition.Center
                HUD.dismissAfterDelay(1, animated: true)
                self.updateUserNotificationRegistration(false)
            } else {
                // If a token does not exist but the push value is true (say a user delete the app but configured true to push notifications) then configure the api to deregister but without removing the token
                let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
                HUD.showInView(self.view!)
                HUD.textLabel.text = "Push Notifications are Off"
                HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                HUD.position = JGProgressHUDPosition.Center
                HUD.dismissAfterDelay(1, animated: true)
                self.updateUserNotificationRegistration(false)
                print("no device token found, cannot deregister")
            }
        }
    }
    
    func promptUserToRegisterPushNotifications(sender: AnyObject) {
        // Register for Push Notifications
        print("registering push")
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Push Notifications are On"
        HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        HUD.position = JGProgressHUDPosition.Center
        HUD.dismissAfterDelay(1, animated: true)
        if let userDeviceToken = KeychainSwift().get("deviceToken") {
            updateUserDeviceToken(userDeviceToken)
            print("push notifications enabled", userDeviceToken)
        }
        // Use below for in-controller registration
        // self.pushNotificationsController = ConfigureNotificationsViewController()
//        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
//            print("registering push")
//            let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
//            HUD.showInView(self.view!)
//            HUD.textLabel.text = "Push Notifications are On"
//            HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
//            HUD.position = JGProgressHUDPosition.Center
//            HUD.dismissAfterDelay(1, animated: true)
//            let userDeviceToken = KeychainSwift().get("deviceToken")
//            updateUserDeviceToken(userDeviceToken!)
//            print("push notifications enabled", userDeviceToken)
            // Enable push notifications
//            if #available(iOS 8.0, *) {
//                let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
//                UIApplication.sharedApplication().registerForRemoteNotifications()
//            } else {
//                let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
//                UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
//            }
//        }
    }
    
    // Get device token for push notification
//    internal func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
//        // let userDeviceToken = KeychainSwift().get("deviceToken")
//        // we can use this to update at the point of view controller down the road
//        // updateUserDeviceToken(userDeviceToken!)
//        // print("user device token registered in app controller is ")
//        // print(userDeviceToken)
//    }
    
    func updateUserDeviceToken(token: String) {
        print("updating user token")
        if userAccessToken != nil {
            print("current auth token for proton", userAccessToken!)
            print("access token not null, setting headers")
            
            let token = token
            print("device token is")
            print(token)
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: AnyObject] = [ "push_state": true, "device_token" : token ] //also works with [ "model" : NSNull()]
            let iosNSDict = iosContent as NSDictionary //no error message
            
            // print(userData?.rawValue)
            // print(userData?["user"]["username"].rawValue)
            let parameters : [String : AnyObject] = [
                "user" : (userData?.rawValue)!,
                "ios" : iosNSDict
            ]
            
            let endpoint = apiUrl + "/v1/profile"
            
            print(endpoint)
            print(parameters)
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        print("success updated device token")
                        if let value = response.result.value {
                            let data = JSON(value)
                             print(data)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func updateUserNotificationRegistration(state: Bool) {
        print("updating notification registration state")
        if userAccessToken != nil {
            print("current auth token for proton", userAccessToken!)
            print("access token not null, setting headers")
            
            let state = String(state.boolValue).toBool()!
            print("state for updateUserNotificationRegistration is")
            print(state)
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: Bool] = [ "push_state" : state ] //also works with [ "model" : NSNull()]
            let iosNSDict = iosContent as NSDictionary //no error message
            
            // print(userData?.rawValue)
            // print(userData?["user"]["username"].rawValue)
            let parameters : [String : AnyObject] = [
                "user" : (userData?.rawValue)!,
                "ios" : iosNSDict
            ]
            
            let endpoint = apiUrl + "/v1/profile"
            
            print(endpoint)
            print(parameters)
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        print("successfully updated the push state to:")
                        if let value = response.result.value {
                            var data = JSON(value)
                            var push = data["ios"]["push_state"]
                            print(push.boolValue)
                            // print(data)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    func getPushState(completionHandler: (Bool?, String?, NSError?) -> ()) {
        print("getting push state")
        if userAccessToken != nil {
            print("current auth token for proton", userAccessToken!)
            print("access token not null, setting headers")
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let endpoint = apiUrl + "/v1/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.GET, endpoint, parameters: [:], encoding: .URL, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        print("got the push state and device token")
                        if let value = response.result.value {
                            var data = JSON(value)
                            var push = data["ios"]["push_state"]
                            var device_token = data["ios"]["device_token"]
                            print(push.boolValue)
                            print(device_token.stringValue)
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

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}