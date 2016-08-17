//
//  SignupIndividualViewControllerThree.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/14/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import TextFieldEffects
import UIColor_Hex_Swift
import BEMCheckBox
import MZAppearance
import MZFormSheetPresentationController
import SCLAlertView
import StepSlider
import OnePasswordExtension
import CWStatusBarNotification
import Crashlytics

class SignupIndividualViewControllerThree: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var agreementButton: UIButton!
    
    let userPassword = KeychainSwift().get("userPassword")!

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var switchTermsAndPrivacy: BEMCheckBox = BEMCheckBox(frame: CGRectMake(0, 0, 60, 60))
    
    // Keychain
    let userUsername = NSUserDefaults.standardUserDefaults().stringForKey("userUsername")!
    let userEmail = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!
    let userLegalEntityType = NSUserDefaults.standardUserDefaults().stringForKey("userLegalEntityType")!
    let userCountry = NSUserDefaults.standardUserDefaults().stringForKey("userCountry")!
    let userDobDay = NSUserDefaults.standardUserDefaults().stringForKey("userDobDay")!
    let userDobMonth = NSUserDefaults.standardUserDefaults().stringForKey("userDobMonth")!
    let userDobYear = NSUserDefaults.standardUserDefaults().stringForKey("userDobYear")!
    
    override func viewDidAppear(animated: Bool) {
        let stepButton = UIBarButtonItem(title: "3/3", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightBlue()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
            ], forState: .Normal)
        
        self.finishButton.enabled = false
        // Allow continue to be clicked
        let _ = Timeout(0.3) {
            self.finishButton.userInteractionEnabled = true
            self.finishButton.enabled = true
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.view.backgroundColor = UIColor.whiteColor()

        let stepper = StepSlider()
        stepper.frame = CGRect(x: 30, y: 65, width: screenWidth-60, height: 15)
        stepper.index = 2
        stepper.trackColor = UIColor.whiteColor()
        stepper.trackHeight = 2
        stepper.trackCircleRadius = 3
        stepper.sliderCircleColor = UIColor.slateBlue()
        stepper.sliderCircleRadius = 3
        stepper.maxCount = 3
        stepper.tintColor = UIColor.slateBlue()
        stepper.backgroundColor = UIColor.clearColor()
        // self.view.addSubview(stepper)
        
        agreementButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        // Set checkbox animation
        switchTermsAndPrivacy.onAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.offAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.onCheckColor = UIColor.lightBlue()
        switchTermsAndPrivacy.onTintColor = UIColor.lightBlue()
        switchTermsAndPrivacy.lineWidth = 1
        switchTermsAndPrivacy.frame.origin.y = screenHeight-300 // 250 from bottom
        switchTermsAndPrivacy.frame.origin.x = (self.view.bounds.size.width - switchTermsAndPrivacy.frame.size.width) / 2.0
        self.view!.addSubview(switchTermsAndPrivacy)
        
        finishButton.layer.cornerRadius = 0
        finishButton.backgroundColor = UIColor.brandGreen()
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "MyriadPro-Regular", size: 17)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Accept Terms & Privacy")
        navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
        navBar.setItems([navItem], animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {

        finishButton.userInteractionEnabled = false
        
        if(self.switchTermsAndPrivacy.on.boolValue == false) {
            // Display error if terms of service and privacy policy not accepted
            displayErrorAlertMessage("Terms of Service and Privacy Policy were not accepted, could not create account");
            self.finishButton.userInteractionEnabled = true
            return;
        }
        
        // Set WIFI IP immediately on load using completion handler
        getWifiAddress { (addr, error) in
            
            if addr != nil && self.switchTermsAndPrivacy.on == true {
                let calcDate = NSDate().timeIntervalSince1970
                var date: String = "\(calcDate)"
                
                var tosContent: [String: AnyObject] = [ "ip": addr!, "date": date ] //also works with [ "model" : NSNull()]
                let tosNSDict = tosContent as NSDictionary //no error message
                
                var userDeviceToken: String {
                    if let userDeviceToken = KeychainSwift().get("user_device_token_ios") {
                        return userDeviceToken
                    }
                    return ""
                }
                
                let dobJSON: [String: AnyObject] = [ "day": Int(self.userDobDay)!, "month": Int(self.userDobMonth)!, "year": Int(self.userDobYear)! ]
                let dobNSDict = dobJSON as NSDictionary //no error message
                
                let iosContent: [String: AnyObject] = [ "push_state": true, "device_token": userDeviceToken ] //also works with [ "model" : NSNull()]
                let iosNSDict = iosContent as NSDictionary //no error message
                
                let parameters : [String : AnyObject] = [
                    "username":self.userUsername,
                    "country":self.userCountry,
                    "email":self.userEmail,
                    "tos_acceptance" : tosNSDict,
                    "dob" : dobNSDict,
                    "legal_entity_type": self.userLegalEntityType,
                    "password":self.userPassword,
                    "ios": iosNSDict
                ]
                
                let headers = [
                    "Content-Type": "application/json"
                ]
                
                Alamofire.request(.POST, API_URL + "/register", parameters: parameters, encoding:.JSON, headers: headers)
                    .responseJSON { response in

                        
                        if(response.response?.statusCode == 200) {
                            showGlobalNotification("Welcome to Argent", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())

                            // go to main view
                        } else {
                            showGlobalNotification("Error occurred", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandRed())
                        }
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                // potentially use completionHandler/closure in future
                                
                                self.displayOnePasswordAlert()
                                
                                let msg = json["message"].stringValue
                                if msg != "" {
                                    showGlobalNotification(String(json["message"]), duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.skyBlue())
                                }
                                Answers.logSignUpWithMethod("Signup | type: " + self.userLegalEntityType,
                                    success: true,
                                    customAttributes: nil)
                            }
                        case .Failure(let error):
                            print(error)
                            self.finishButton.userInteractionEnabled = true
                            showGlobalNotification(error.localizedDescription, duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandRed())
                            Answers.logSignUpWithMethod("Signup | type: " + self.userLegalEntityType,
                                success: false,
                                customAttributes: nil)
                            break
                        }
                }
                
            } else {
                showGlobalNotification("Registration Error, please check your network connection or date/time settings are correct.", duration: 10.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandRed())
            }
        }
        // TODO: Set keychain username and password
    }
    
    
    func saveToOnePassword(username: String, password: String, email: String) {
        // save credentials to 1Password
        if OnePasswordExtension.sharedExtension().isAppExtensionAvailable() {
            let newLoginDetails:[String: AnyObject] = [
                AppExtensionTitleKey: "Argent",
                AppExtensionUsernameKey: username,
                AppExtensionPasswordKey: password,
                AppExtensionNotesKey: "Saved with the Argent app",
                AppExtensionSectionTitleKey: "Argent Browser",
                AppExtensionFieldsKey: [
                    "email" : email
                    // Add as many string fields as you please.
                ]
            ]
            
            // The password generation options are optional, but are very handy in case you have strict rules about password lengths, symbols and digits.
            let passwordGenerationOptions:[String: AnyObject] = [
                // The minimum password length can be 4 or more.
                AppExtensionGeneratedPasswordMinLengthKey: (8),
                
                // The maximum password length can be 50 or less.
                AppExtensionGeneratedPasswordMaxLengthKey: (30),
                
                // If YES, the 1Password will guarantee that the generated password will contain at least one digit (number between 0 and 9). Passing NO will not exclude digits from the generated password.
                AppExtensionGeneratedPasswordRequireDigitsKey: (true),
                
                // If YES, the 1Password will guarantee that the generated password will contain at least one symbol (See the list bellow). Passing NO with will exclude symbols from the generated password.
                AppExtensionGeneratedPasswordRequireSymbolsKey: (true),
                
                // Here are all the symbols available in the the 1Password Password Generator:
                // !@#$%^&*()_-+=|[]{}'\";.,>?/~`
                // The string for AppExtensionGeneratedPasswordForbiddenCharactersKey should contain the symbols and characters that you wish 1Password to exclude from the generated password.
                AppExtensionGeneratedPasswordForbiddenCharactersKey: "!@#$%/0lIO"
            ]
            
            OnePasswordExtension.sharedExtension().storeLoginForURLString("https://www.argentapp.com", loginDetails: newLoginDetails, passwordGenerationOptions: passwordGenerationOptions, forViewController: self, sender: self) { (loginDictionary, error) -> Void in
                if loginDictionary == nil {
                    if error!.code != Int(AppExtensionErrorCodeCancelledByUser) {
                        print("Error invoking 1Password App Extension for find login: \(error)")
                        self.goToAuth(self)
                    }
                    self.goToAuth(self)
                    return
                }
                self.goToAuth(self)
                print("Success 1Password")
            }
        }
    }
    
    func displayOnePasswordAlert() {
        let refreshAlert = UIAlertController(title: "1Password", message: "Would you like to save your login credentials to 1Password?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes Please!", style: .Default, handler: { (action: UIAlertAction!) in
            if OnePasswordExtension.sharedExtension().isAppExtensionAvailable() == false {
                let alertController = UIAlertController(title: "1Password is not installed", message: "Get 1Password from the App Store for " + APP_NAME + " Single Sign On", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                    self.goToAuth(self)
                })
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Get 1Password", style: .Default) { (action) in UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/app/1password-password-manager/id568903335")!)
                }
                
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.saveToOnePassword(self.userUsername, password: self.userPassword, email: self.userEmail)
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "No Thank You", style: .Cancel, handler: { (action: UIAlertAction!) in
            self.goToAuth(self)
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    // Return to auth view func
    func goToAuth(sender: AnyObject) {
        // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
        let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
        self.presentViewController(viewController, animated: true, completion: nil)
        let _ = Timeout(0.5) {
            showGlobalNotification("Welcome to " + APP_NAME + "!", duration: 4, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.oceanBlue())
        }
    }
    
    
    func displayErrorAlertMessage(alertMessage:String) {
        showAlert(.Error, title: "Error", msg: alertMessage)
        self.view.endEditing(true)
    }

    // Return IP address of WiFi interface (en0) as a String, or `nil`
    // Used for accepting terms of service
    func getWifiAddress(completionHandler: (String?, NSError?) -> ()) -> () {
        Alamofire.request(.GET, "https://api.ipify.org").responseString { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let response = value
                    let address = response
                    completionHandler(address, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // Set up modal view for terms and privacy
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "presentModal" {
                
                // Initialize and style the terms and conditions modal
                let presentationSegue = segue as! MZFormSheetPresentationViewControllerSegue
                presentationSegue.formSheetPresentationController.presentationController?.shouldApplyBackgroundBlurEffect = true
                presentationSegue.formSheetPresentationController.presentationController?.shouldUseMotionEffect = true
                presentationSegue.formSheetPresentationController.presentationController?.contentViewSize = CGSizeMake(300, 250)
                presentationSegue.formSheetPresentationController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
                presentationSegue.formSheetPresentationController.presentationController?.containerView?.sizeToFit()
                presentationSegue.formSheetPresentationController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
                presentationSegue.formSheetPresentationController.presentationController?.shouldDismissOnBackgroundViewTap = true
                presentationSegue.formSheetPresentationController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
                presentationSegue.formSheetPresentationController.contentViewCornerRadius = 15
                presentationSegue.formSheetPresentationController.allowDismissByPanningPresentedView = true
                presentationSegue.formSheetPresentationController.interactivePanGestureDismissalDirection = .All;

                // Blur will be applied to all MZFormSheetPresentationControllers by default
                MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
                
                let navigationController = presentationSegue.formSheetPresentationController.contentViewController as! UINavigationController
                
                let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
                presentedViewController.passingString1 = "Terms and Conditions"
                presentedViewController.passingString2 = "Privacy Policy"
            }
        }
    }
    
    
}