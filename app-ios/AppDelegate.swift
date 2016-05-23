
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
import TransitionTreasury
import TransitionAnimation
import PermissionScope
import Alamofire

let merchantID = "merchant.com.argentapp.pay.v2"

// Get Local IP address by looking by using ifconfig command at terminal and looking below the 'inet' value
// Make sure the physical device is connected to the same wifi network
// Add exception for your IP address in info.plist file so regular http requests can be made
// To perform the above, right click 'add row' and make that row a dictionary value, set NSExceptionAllowsInsecureHTTPLoads to YES
// In case this doesnt work, make sure NSTransportSecurity has the sub-item Allow Arbitrary Loads set to YES
// DEV

// For provisioning profile naming convention http://stackoverflow.com/questions/20565565/an-app-id-with-identifier-is-not-available-please-enter-a-different-string

// let apiUrl = "http://localhost:5001"
// let apiUrl = "http://192.168.1.182:5001"
// let apiUrl = "http://192.168.1.232:5001"
 let apiUrl = "http://api.argent.cloud"
// PROD
//let apiUrl = "https://api.argent.cloud"

// Global Stripe base API url
let stripeApiUrl = "https://api.stripe.com"

// For push notifications make sure to delete and re-install app, fix this bug later
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TRTabBarControllerDelegate {
    
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
        
        if let appContentVC = UIStoryboard(name: "Auth", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("authViewController") as? UIViewController {
            let overlayView: UIView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
            appContentVC.view.addSubview(overlayView)
            self.window?.rootViewController = appContentVC
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
            }
        } else if shortcutItem.type == "com.argentapp.ios.search" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        } else if shortcutItem.type == "com.argentapp.ios.menu" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 2
            }
        } else if shortcutItem.type == "com.argentapp.ios.account" {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 4
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
    
    private func showViewController(viewControllerId: String) -> Bool {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = sb.instantiateViewControllerWithIdentifier(viewControllerId)
        guard let root = UIApplication.sharedApplication().keyWindow?.rootViewController else { return false }
        root.presentViewController(rootVC, animated: false, completion: { () -> Void in })
        return true
    }
    
    // Transition Treasury
    func tr_tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("You did select \(viewController.dynamicType).")
    }
    
    // Default Launch
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Transitions 
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.tr_transitionDelegate = TRTabBarTransitionDelegate(method: TRTabBarTransitionMethod.Slide)
            tabBarController.tr_delegate = self
        }
        
        // Set push notification badge to zero
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Setup skip onboarding notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.skipOnboarding(_:)), name: "kDismissOnboardingNotification", object: nil)
        
        // Globally set toolbar
        UIToolbar.appearance().barTintColor = UIColor.mediumBlue()
        UIToolbar.appearance().backgroundColor = UIColor.mediumBlue()
        
        // Screen Dimming Enable
        let dim = KeychainSwift().getBool("screenAlive")
        if dim != nil && dim == true {
            UIApplication.sharedApplication().idleTimerDisabled = true
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = false
        }
        
        // Toolbar Keyboard UI
        if let font = UIFont(name: "Avenir-Book", size: 15) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        }
        
        // Tabbar UI
        UITabBar.appearance().tintColor = UIColor.slateBlue()
        
        // Initialize Plaid, change to .Production before golive
        Plaid.sharedInstance().setPublicKey("fb32b0520292ad69be7b4d1ade4bd3")
        
        // Globally dark keyboard
        UITextField.appearance().keyboardAppearance = .Light
        
        // UPDATE TO LIVE BEFORE RELEASING PROD
        // Enable Stripe DEV
         Stripe.setDefaultPublishableKey("pk_test_6MOTlPN5JrNS5dIN4DUeKFDA")

        // Enable Stripe PROD
        // Stripe.setDefaultPublishableKey("pk_live_9kfmn7pMRPKAYSpcf1Fmn266")

        // Override point for customization after application launch.
        // Set UINavigationBar
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
        UISearchBar.appearance().tintColor = UIColor.mediumBlue()
        
        // Set up permissions
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "Welcome to Argent!  Enable feature to receive push notifications on account events")
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
        
        // Global window attributes
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.slateBlue()
        self.window!.makeKeyAndVisible()
        self.window!.makeKeyWindow()

        // Assign the init view controller of the app
        let x = KeychainSwift().getBool("firstTime")
        if x == true || x == nil {
            KeychainSwift().set(false, forKey: "firstTime")
            let viewController = AuthViewController()
            // Show dialog with callbacks
            pscope.show({ finished, results in
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
            self.window!.rootViewController = viewController
        } else {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewController")
            self.window!.rootViewController = viewController
        }
        
        // Save state tab bar
        if let tabBarController = window?.rootViewController as? UITabBarController {
            guard let activeTab = NSUserDefaults.standardUserDefaults().valueForKey("activeTab") else {
                return false
            }
            passcodeLockPresenter.presentPasscodeLock()
            tabBarController.selectedIndex = Int(activeTab as! NSNumber)
        }

        return true
    }

    // Get device token for push notification
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        KeychainSwift().set(deviceTokenString, forKey: "deviceToken")
        //print( deviceTokenString )
        addPushTokenToUser(deviceTokenString)
    }
    
    func addPushTokenToUser(token: String) {
        if userAccessToken != nil {
            
            let token = KeychainSwift().get("deviceToken")
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]
            
            let iosContent: [String: AnyObject] = [ "push_state": true, "device_token" : token! ]

            let iosNSDict = iosContent as NSDictionary //no error message
            
            let parameters : [String : AnyObject] = [
                "ios" : iosNSDict
            ]
            
            let endpoint = apiUrl + "/v1/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            _ = JSON(value)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("applicationWillResignActive") //ignore  
        print(application)
    }

    func applicationDidEnterBackground(application: UIApplication) {
        /*
         Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
         If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         */
        //Remember the users last tab selection
        if let tabBarController = window?.rootViewController as? UITabBarController {
            let tabIndex: Int = tabBarController.selectedIndex
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setInteger(tabIndex, forKey: "activeTab")
            print(userDefaults)
            if !userDefaults.synchronize() {
                print("Error Synchronizing NSUserDefaults")
            }
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        /*
         Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         */
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        print(application)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate") //ignore
        print(application)
    }
    
    // Error solution for app rename with cocoapods configuration update https://github.com/CocoaPods/CocoaPods/issues/2627
    // Make sure to quit xcode, delete podfile.lock, pod install, cmd shift k, cmd shift b
    
    // Error solution for dyld_sim`dyld_fatal_error nop
    // Delete ~/Library/Caches/com.apple.dt.Xcode*
    // Delete ~/Library/Developer/Xcode/DerivedData
    // Clean and Build
    // Edit scheme to run automatically, run after launch confirm,, and back to run automatically
    // http://stackoverflow.com/questions/24878274/getting-dyld-fatal-error-after-updating-to-xcode-6-beta-4-using-swift
}