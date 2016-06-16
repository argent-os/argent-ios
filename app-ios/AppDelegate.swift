
//  AppDelegate.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.

import Foundation
import UIKit
import Stripe
import PasscodeLock
import SwiftyJSON
import KeychainSwift
import plaid_ios_sdk
import PermissionScope
import Alamofire
import Fabric
import Crashlytics
import Armchair
import MTZWhatsNew

// THEME
var APP_THEME = "LIGHT"

// CONFIG
let MERCHANT_ID = "merchant.com.argentapp.pay.v3"
let APP_URL = "https://itunes.apple.com/us/app/argent/id1110084542?mt=8"
let APP_ID = "1110084542"
let APP_NAME = "Argent"

// PLAID
let PLAID_PUBLIC_KEY_TEST = "fb32b0520292ad69be7b4d1ade4bd3"
let PLAID_PUBLIC_KEY_LIVE = "fb32b0520292ad69be7b4d1ade4bd3"

// STRIPE
let STRIPE_PUBLIC_KEY_TEST = "pk_test_6MOTlPN5JrNS5dIN4DUeKFDA"
let STRIPE_PUBLIC_KEY_LIVE = "pk_live_9kfmn7pMRPKAYSpcf1Fmn266"

// LOCAL TESTING
//let API_URL = "http://localhost:5001/v1" // Works in simulator
//let API_URL = "http://192.168.1.182:5001/v1" // Works in MA
let API_URL = "http://192.168.1.232:5001/v1" // Works in VA

// API ENDPOINT V1
//let API_URL = "https://dev.argent.cloud/v1"
//let API_URL = "https://stage.argent.cloud/v1"
//let API_URL = "https://api.argent.cloud/v1"

// ENVIRONMENT
let ENVIRONMENT = "DEV"
//let ENVIRONMENT = "PROD"

// Pre-production check | Change ENVIRONMENT to PROD, Change API_URL to https://api.argent.cloud/v1

// For push notifications make sure to delete and re-install app, fix this bug later
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let pscope = PermissionScope()
    
    // Passcode Lock
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        let configuration = PasscodeLockConfiguration()
        let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration)
        return presenter
    }()
    
    // Onboarding
    func skipOnboarding(notification: NSNotification) {
        // Allows the user to skip the onboarding
        // process page if they clicked on it
        // accidentaly or do not want to complete it
        if let appContentVC = UIStoryboard(name: "Auth", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("authViewController") as? UIViewController {
            let overlayView: UIView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            appContentVC.view.addSubview(overlayView)
            self.window?.rootViewController = appContentVC
            Answers.logCustomEventWithName("Onboarding Skip",
                                           customAttributes: [:])
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                overlayView.alpha = 0
                }, completion: { (finished) -> Void in
                    overlayView.removeFromSuperview()
            })
        }
    }
    
    // 3D Touch
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> ()) {
        if shortcutItem.type == "com.argentapp.ios.dashboard" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                Answers.logCustomEventWithName("3D Touch to Dashboard",
                                               customAttributes: [:])
            }
        } else if shortcutItem.type == "com.argentapp.ios.search" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
                Answers.logCustomEventWithName("3D Touch to Search",
                                               customAttributes: [:])
            }
        } else if shortcutItem.type == "com.argentapp.ios.menu" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 2
                Answers.logCustomEventWithName("3D Touch to Menu",
                                               customAttributes: [:])
            }
        } else if shortcutItem.type == "com.argentapp.ios.account" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 4
                Answers.logCustomEventWithName("3D Touch to Account",
                                               customAttributes: [:])
            }
        } else {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                guard let activeTab = NSUserDefaults.standardUserDefaults().valueForKey("activeTab") else {
                    return
                }
                tabBarController.selectedIndex = Int(activeTab as! NSNumber)
            }
        }
    }
    
    func displayNewFeatures() {
        // init with nib
//        let vc: MTZWhatsNewGridViewController = MTZWhatsNewGridViewController.init(nibName: "", bundle: <#T##NSBundle?#>)
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
//        self.window!.rootViewController = viewController
//        viewController.presentViewController(vc, animated: false, completion: { _ in
//            print("showing whats new")
//        })
//        MTZWhatsNew.handleWhatsNew { ( dic : [NSObject : AnyObject]!) in
//            let vc: MTZWhatsNewGridViewController = MTZWhatsNewGridViewController(features: dic)
//            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
//            self.window!.rootViewController = viewController
//            viewController.presentViewController(vc, animated: false, completion: { _ in
//                print("showing whats new")
//            })
//        }
    }
    
    
    // Default Launch
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //MTZWhatsNew.performSelector(Selector("setLastAppVersion:"), withObject: "0.0")
        //displayNewFeatures()
        
        // Set global app theme
        if (KeychainSwift().get("theme") == "DARK") {
            APP_THEME = "DARK"
        } else {
            APP_THEME = "LIGHT"
        }
        
        // It is always best to load Armchair as early as possible
        // because it needs to receive application life-cycle notifications
        // NOTE: The appID call always has to go before any other Armchair calls
        Armchair.appID(APP_ID)
        Armchair.debugEnabled(true)
        
        // Fabric & Crashlytics / Answers
        Fabric.with([STPAPIClient.self, Crashlytics.self])
        Answers.logCustomEventWithName("Application Launched",
                                       customAttributes: [:])
        
        // Setup skip onboarding notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.skipOnboarding(_:)), name: "kDismissOnboardingNotification", object: nil)
        
        // Screen Dimming Enable
        let dim = KeychainSwift().getBool("screenAlive")
        if dim != nil && dim == true {
            UIApplication.sharedApplication().idleTimerDisabled = true
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
        
        // Initialize Plaid, change to .Production before golive
        if ENVIRONMENT == "DEV" {
            Plaid.sharedInstance().environment = .Tartan
            Plaid.sharedInstance().setPublicKey(PLAID_PUBLIC_KEY_TEST)
            Stripe.setDefaultPublishableKey(STRIPE_PUBLIC_KEY_TEST)
            Armchair.debugEnabled(true)
        } else if ENVIRONMENT == "PROD" {
            Plaid.sharedInstance().environment = .Production
            Plaid.sharedInstance().setPublicKey(PLAID_PUBLIC_KEY_LIVE)
            Stripe.setDefaultPublishableKey(STRIPE_PUBLIC_KEY_LIVE)
            Armchair.debugEnabled(false)
        }
        
        // Set up permissions scope
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: APP_NAME + " is requesting permission to send push notifications on account events")
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
        
        // Register for push notification on every launch
        notify()

        // Global window attributes
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.clearColor()
        self.window!.makeKeyAndVisible()
        self.window!.makeKeyWindow()
        
        // Initialize global UI elements ** Must come after setting self.window attributes
        globalUI()
        
        // initialize rootviewcontroller *important
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
        self.window!.rootViewController = viewController
        // Assign the init view controller of the app
        firstTime()
        
        // Save state tab bar
        if let tabBarController = window?.rootViewController as? UITabBarController {
            // print(UIApplication.sharedApplication().applicationIconBadgeNumber)
            for item in tabBarController.tabBar.items! {
                if let image = item.image {
                    item.image = image.imageWithRenderingMode(.AlwaysOriginal)
                    if UIApplication.sharedApplication().applicationIconBadgeNumber != 0 {
                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                        tabBarController.tabBar.items![3].badgeValue = "1"
                        let _ = Timeout(5) {
                            tabBarController.tabBar.items![3].badgeValue = nil
                        }
                    }
                    
                }
            }
            guard let activeTab = NSUserDefaults.standardUserDefaults().valueForKey("activeTab") else {
                return false
            }
            passcodeLockPresenter.presentPasscodeLock()
            Answers.logCustomEventWithName("Application Security Did Launch",
                                           customAttributes: [:])
            tabBarController.selectedIndex = Int(activeTab as! NSNumber)
        }
        
        return true
    }
    
    func globalUI() {
        // here we establish any global UI elements
        // that affect the entire application such
        // as keyboards, navigation bars, and tabbars
        
        // Set notification badge to zero on launch
        // UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Globally set toolbar
        UIToolbar.appearance().barTintColor = UIColor.mediumBlue()
        UIToolbar.appearance().backgroundColor = UIColor.mediumBlue()
        
        // Toolbar Keyboard UI
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15),NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        
        // Tabbar UI
        UITabBar.appearance().tintColor = UIColor.slateBlue()
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
        
        // Globally dark keyboard
        UITextField.appearance().keyboardAppearance = .Light
        
        // Navbar UI
        UINavigationBar.appearance().barStyle = .Black
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().translucent = true
        
        // Search Bar UI
        UISearchBar.appearance().barTintColor = UIColor.whiteColor()
        UISearchBar.appearance().tintColor = UIColor.lightBlue()
    }
    
    func firstTime() {
        // Set up a user entering for the first time
        // if true it will prompt a pscope
        //
        // if denied access users can change permissions later
        // display root controller otherwise
        guard let firstTime = NSUserDefaults.standardUserDefaults().valueForKey("firstTime") else {
            // IMPORTANT: load new access token on appdelegate load, otherwise the old token will be requested to the server
            userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")
            if userAccessToken != nil {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
                self.window!.rootViewController = viewController
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
                let vc = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                vc.modalTransitionStyle = .CrossDissolve
                self.window!.rootViewController = rootViewController
                rootViewController.presentViewController(vc, animated: false, completion: { _ in
                    print("showing login")
                })
            }
            return
        }

        if String(firstTime) == "" {
            
            Answers.logCustomEventWithName("First Time Launch",
                                           customAttributes: [:])
            
            NSUserDefaults.standardUserDefaults().setValue("launched", forKey: "firstTime")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let sb = UIStoryboard(name: "Auth", bundle: nil)
            let rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
            let vc = sb.instantiateViewControllerWithIdentifier("authViewController")
            vc.modalTransitionStyle = .CrossDissolve
            self.window!.rootViewController = rootViewController
            rootViewController.presentViewController(vc, animated: false, completion: { _ in
                print("showing auth")
            })
            
            // Show dialog with callbacks
            pscope.show({ finished, results in
                // Enable push notifications
                if #available(iOS 8.0, *) {
                    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
                    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                    UIApplication.sharedApplication().registerForRemoteNotifications()
                    Answers.logCustomEventWithName("Permission Notifications Enabled",
                        customAttributes: [:])
                } else {
                    let settings = UIRemoteNotificationType.Alert.union(UIRemoteNotificationType.Badge).union(UIRemoteNotificationType.Sound)
                    UIApplication.sharedApplication().registerForRemoteNotificationTypes(settings)
                    Answers.logCustomEventWithName("Permission Notifications Enabled",
                        customAttributes: [:])
                }
                }, cancelled: { (results) -> Void in
                    // print("cancelled")
                    Answers.logCustomEventWithName("Permission Notifications Cancelled",
                        customAttributes: [:])
            })
        }
    }
    
    // Get device token for push notification
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        // post device token on each device launch
        // adapts to changing notification status
        //
        // TODO: implement new token retrival at point
        // of change notification setting
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        KeychainSwift().set(deviceTokenString, forKey: "deviceToken")
        // print( deviceTokenString )
        addPushTokenToUser(deviceTokenString)
        
        Answers.logCustomEventWithName("User Registered For Push Notifications",
                                       customAttributes: [:])
    }
    
    func addPushTokenToUser(token: String) {
        // pushes new device token to user profile
        if userAccessToken != nil {
            
            let token = KeychainSwift().get("deviceToken")
            
            print(token)
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: AnyObject] = [ "push_state": true, "device_token" : token! ]
            
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
                            Answers.logCustomEventWithName("Added Push Token",
                                customAttributes: [:])
                        }
                    case .Failure(let error):
                        // print(error)
                        Answers.logCustomEventWithName("Push token addition failed",
                            customAttributes: [
                                "error": error.localizedDescription
                            ])
                    }
            }
        }
    }
    
    func notify() {
        switch PermissionScope().statusNotifications() {
        case .Unknown:
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
        case .Unauthorized, .Disabled:
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
        case .Authorized:
            // If permission is granted, post to endpoint
            Answers.logCustomEventWithName("Permission Notifications Authorized in AppDelegate",
                                           customAttributes: [:])
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("applicationWillResignActive") //ignore
        
        Answers.logCustomEventWithName("Application Will Resign Active",
                                       customAttributes: [:])
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        /*
         Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
         If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         */
        //Remember the users last tab selection
        if let tabBarController = window?.rootViewController as? UITabBarController {
            for item in tabBarController.tabBar.items! {
                if let image = item.image {
                    item.image = image.imageWithRenderingMode(.AlwaysOriginal)
                }
            }
            // Uses the original colors for your images, so they aren't not rendered as grey automatically.
            let tabIndex: Int = tabBarController.selectedIndex
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setInteger(tabIndex, forKey: "activeTab")
            
            if !userDefaults.synchronize() {
                print("Error Synchronizing NSUserDefaults")
            }
        }
        
        
        Answers.logCustomEventWithName("Application Did Enter Background",
                                       customAttributes: [:])
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        /*
         Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         */
        
        Answers.logCustomEventWithName("Application Did Become Active",
                                       customAttributes: [:])
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        
        Answers.logCustomEventWithName("Application Will Enter Foreground",
                                       customAttributes: [:])
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate") //ignore
        
        Answers.logCustomEventWithName("Application Terminated",
                                       customAttributes: [:])
    }
    
    // Bug Fix Log
    
    // Error solution for app rename with cocoapods configuration update https://github.com/CocoaPods/CocoaPods/issues/2627
    // Make sure to quit xcode, delete podfile.lock, pod install, cmd shift k, cmd shift b
    
    // Error solution for dyld_sim`dyld_fatal_error nop
    // Delete ~/Library/Caches/com.apple.dt.Xcode*
    // Delete ~/Library/Developer/Xcode/DerivedData
    // Clean and Build
    // Edit scheme to run automatically, run after launch confirm,, and back to run automatically
    // http://stackoverflow.com/questions/24878274/getting-dyld-fatal-error-after-updating-to-xcode-6-beta-4-using-swift
    
    
    // Get Local IP address by looking by using ifconfig command at terminal and looking below the 'inet' value
    // Make sure the physical device is connected to the same wifi network
    // Add exception for your IP address in info.plist file so regular http requests can be made
    // To perform the above, right click 'add row' and make that row a dictionary value, set NSExceptionAllowsInsecureHTTPLoads to YES
    // In case this doesnt work, make sure NSTransportSecurity has the sub-item Allow Arbitrary Loads set to YES
    // DEV
    
    // For provisioning profile naming convention http://stackoverflow.com/questions/20565565/an-app-id-with-identifier-is-not-available-please-enter-a-different-string
}