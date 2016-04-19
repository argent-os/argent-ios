
//  AppDelegate.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.

import Foundation
import UIKit
import Stripe
import PasscodeLock
import SwiftyJSON
import KeychainSwift

let merchantID = "merchant.com.paykloud"
var userData:JSON? // init user data, declare globally, needs SwiftyJSON

// Get Local IP address by looking by using ifconfig command at terminal and looking below the 'inet' value
// Make sure the physical device is connected to the same wifi network
// Add exception for your IP address in info.plist file so regular http requests can be made
// To perform the above, right click 'add row' and make that row a dictionary value, set NSExceptionAllowsInsecureHTTPLoads to YES
// In case this doesnt work, make sure NSTransportSecurity has the sub-item Allow Arbitrary Loads set to YES
// DEV

// let apiUrl = "http://localhost:5001"
// let apiUrl = "http://192.168.1.182:5001"
 let apiUrl = "http://192.168.1.232:5001"
// let apiUrl = "http://proton-api-dev.us-east-1.elasticbeanstalk.com"
// PROD
//let apiUrl = "http://api.protonpayments.com"

// Global Stripe base API url
let stripeApiUrl = "https://api.stripe.com"

// For push notifications make sure to delete and re-install app, fix this bug later
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Assign the init view controller of the app
    var viewController = AuthViewController()
    
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        
        let configuration = PasscodeLockConfiguration()
        let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration)
        return presenter
    }()

    // 3D Touch
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        if shortcutItem.type == "com.protonpayments.app.add-customer" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let addCustomerVC = sb.instantiateViewControllerWithIdentifier("AddCustomerViewController")
            let root = UIApplication.sharedApplication().keyWindow?.rootViewController
            root!.presentViewController(addCustomerVC, animated: false, completion: { () -> Void in
                completionHandler(true)
            })
        }
        if shortcutItem.type == "com.protonpayments.app.add-plan" {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let recurringBillingVC = sb.instantiateViewControllerWithIdentifier("RecurringBillingViewController")
            let root = UIApplication.sharedApplication().keyWindow?.rootViewController
            root!.presentViewController(recurringBillingVC, animated: false, completion: { () -> Void in
                completionHandler(true)
            })
        }
        if shortcutItem.type == "com.protonpayments.app.make-payment" {
            print("sending to add customer view controller")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let chargeVC = sb.instantiateViewControllerWithIdentifier("ChargeViewController")
            let root = UIApplication.sharedApplication().keyWindow?.rootViewController
            root!.presentViewController(chargeVC, animated: false, completion: { () -> Void in
                completionHandler(true)
            })
        }

    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barStyle = .Black

        // Globally set toolbar
        UIToolbar.appearance().barTintColor = UIColor(rgba: "#1796fa")
        UIToolbar.appearance().backgroundColor = UIColor(rgba: "#1796fa")
        
        if let font = UIFont(name: "Nunito-SemiBold", size: 15) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
            
        }
        
        // Initialize Plaid, change to .Production before golive
        Plaid.initializePlaid(.Testing)
        
        // Display PasscodeLock on Launch
        passcodeLockPresenter.presentPasscodeLock()
        
        // Globally dark keyboard
        UITextField.appearance().keyboardAppearance = .Light
        
        // UPDATE TO LIVE BEFORE RELEASING PROD
        // Enable Stripe DEV
         Stripe.setDefaultPublishableKey("pk_test_6MOTlPN5JrNS5dIN4DUeKFDA")

        // Enable Stripe PROD
        // Stripe.setDefaultPublishableKey("pk_live_9kfmn7pMRPKAYSpcf1Fmn266")

        // Enable push notifications
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
        }

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = viewController
        // Global background color
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        self.window!.makeKeyWindow()
        
        return true
    }

    // Get device token for push notification
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        KeychainSwift().set(deviceTokenString, forKey: "deviceToken")
        print( deviceTokenString )
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //viewController.pauseVideo()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //viewController.playVideo()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
// Fixes Push notification bug: _handleNonLaunchSpecificActions
extension UIApplication {
    func _handleNonLaunchSpecificActions(arg1: AnyObject, forScene arg2: AnyObject, withTransitionContext arg3: AnyObject, completion completionHandler: () -> Void) {
        //catching handleNonLaunchSpecificActions:forScene exception on app close
    }
}

