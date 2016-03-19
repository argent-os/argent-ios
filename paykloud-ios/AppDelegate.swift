
//  AppDelegate.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.

import UIKit
import Stripe
import Firebase
import PasscodeLock
import SwiftyJSON
import KeychainSwift
import SVProgressHUD

let merchantID = "merchant.com.paykloud"
var userData:JSON? // init user data, declare globally, needs SwiftyJSON

// Get Local IP address by looking by using ifconfig command at terminal and looking below the 'inet' value
// Make sure the physical device is connected to the same wifi network
// Add exception for your IP address in info.plist file so regular http requests can be made
// To perform the above, right click 'add row' and make that row a dictionary value, set NSExceptionAllowsInsecureHTTPLoads to YES
// In case this doesnt work, make sure NSTransportSecurity has the sub-item Allow Arbitrary Loads set to YES
// DEV
 let firebaseUrl = Firebase(url:"https://demosandbox.firebaseio.com/api/v1")
// let apiUrl = "http://localhost:5001"
 let apiUrl = "http://192.168.1.182:5001"
// let apiUrl = "http://192.168.1.232:5001"
// let apiUrl = "http://paykloud-api-dev-v1.us-east-1.elasticbeanstalk.com"
// PROD
//let firebaseUrl = Firebase(url:"https://paykloud.firebaseio.com/api/v1")
//let apiUrl = "http://api.paykloud.com"

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
    
//    // Hiding Status Bar
//    override public func prefersStatusBarHidden() -> Bool {
//        return true
//    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barStyle = .Black

        // Initialize Plaid, change to .Production before golive
        Plaid.initializePlaid(.Testing)
        
        // Display PasscodeLock on Launch
        passcodeLockPresenter.presentPasscodeLock()

        // Customize SVProgressHUD
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setRingThickness(4.0)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.Flat)
        SVProgressHUD.setForegroundColor(UIColor(rgba: "#ffffff"))
        SVProgressHUD.setBackgroundColor(UIColor(rgba:"#1aa8f6"))
        
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
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        KeychainSwift().set(deviceTokenString, forKey: "user_device_token_ios")
        
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

