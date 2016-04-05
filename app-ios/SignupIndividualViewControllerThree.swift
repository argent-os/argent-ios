//
//  SignupIndividualViewControllerThree.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/14/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD
import KeychainSwift
import TextFieldEffects
import UIColor_Hex_Swift
import BEMCheckBox
import MZAppearance
import MZFormSheetPresentationController
import SIAlertView

class SignupIndividualViewControllerThree: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var agreementButton: UIButton!
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var switchTermsAndPrivacy: BEMCheckBox = BEMCheckBox(frame: CGRectMake(0, 0, 50, 50))
    
    // Keychain
    let userUsername = NSUserDefaults.standardUserDefaults().stringForKey("userUsername")!
    let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("userEmail")!
    let userLegalEntityType = NSUserDefaults.standardUserDefaults().stringForKey("userLegalEntityType")!
    
    // Set the locale
    let countryCode = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as! String
    
    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {        
        let stepButton = UIBarButtonItem(title: "3/3", style: UIBarButtonItemStyle.Plain, target: nil, action: Selector(""))
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayColor()
        
        self.finishButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            self.finishButton.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
        agreementButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        //        print("user first name", userFirstName)
        //        print("user last name", userLastName)
        //        print("user username", userUsername)
        //        print("user email", userEmail)
        //        print("user phone", userPhoneNumber)
        //        print(countryCode)
        
        
        let screen = UIScreen.mainScreen().bounds
        _ = screen.size.width
        let screenHeight = screen.size.height
        
        // Set checkbox animation
        switchTermsAndPrivacy.onAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.offAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.onCheckColor = UIColor(rgba: "#1aa8f6")
        switchTermsAndPrivacy.onTintColor = UIColor(rgba: "#1aa8f6")
        switchTermsAndPrivacy.frame.origin.y = screenHeight*0.63 // 75 down from the top
        switchTermsAndPrivacy.frame.origin.x = (self.view.bounds.size.width - switchTermsAndPrivacy.frame.size.width) / 2.0
        self.view!.addSubview(switchTermsAndPrivacy)
        
        finishButton.layer.cornerRadius = 0
        finishButton.backgroundColor = UIColor(rgba: "#38a4f9")
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(1)
        
        if(self.switchTermsAndPrivacy.on.boolValue == false) {
            // Display error if terms of service and privacy policy not accepted
            displayErrorAlertMessage("Terms of Service and Privacy Policy were not accepted, could not create account");
            return;
        }
        
        // Set WIFI IP immediately on load using completion handler
        getWifiAddress { (addr, error) in
            if addr != nil && self.switchTermsAndPrivacy.on == true {
                let calcDate = NSDate().timeIntervalSince1970
                var date: String = "\(calcDate)"
                
                var tosContent: [String: AnyObject] = [ "ip": addr!, "date": date ] //also works with [ "model" : NSNull()]
                var tosJSON: [String: [String: AnyObject]] = [ "data" : tosContent ]
                let tosNSDict = tosJSON as NSDictionary //no error message
                
                let userPassword = KeychainSwift().get("userPassword")!
                var userDeviceToken: String {
                    if let userDeviceToken = KeychainSwift().get("user_device_token_ios") {
                        return userDeviceToken
                    }
                    return ""
                }
                
                let parameters : [String : AnyObject] = [
                    "username":self.userUsername,
                    "country":self.countryCode,
                    "email":self.userEmail,
                    "tos_acceptance" : tosNSDict,
                    "legal_entity_type": self.userLegalEntityType,
                    "password":userPassword,
                    "device_token_ios": userDeviceToken
                ]
                Alamofire.request(.POST, apiUrl + "/v1/register", parameters: parameters, encoding:.JSON)
                    .responseJSON { response in
                        //print(response.request) // original URL request
                        //print(response.response?.statusCode) // URL response
                        //print(response.data) // server data
                        //print(response.result) // result of response serialization
                        
                        if(response.response?.statusCode == 200) {
                            // Login is successful
                            NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn");
                            NSUserDefaults.standardUserDefaults().synchronize();
                            
                            print("response 200 success")
                            // go to main view
                            self.performSegueWithIdentifier("loginView", sender: self);
                        } else {
                            self.displayErrorAlertMessage("Registration Error, username or email already taken.")
                            print("failed to signup")
                        }
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                // potentially use completionHandler/closure in future
                                print("Response: \(json)")
                                // assign userData to self, access globally
                                print("register success")
                                self.displaySuccessAlertMessage("Registration Successful!  You can now login.")
                            }
                        case .Failure(let error):
                            print("failed to signup", error)
                            self.displayErrorAlertMessage("Registration Error, username or email already taken.")
                            break
                        }
                }
                
            } else {
                self.displayErrorAlertMessage("Registration Error, please check your network connection or date/time settings.")
            }
        }
        // TODO: Set keychain username and password
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let alertView: SIAlertView = SIAlertView(title: "Error", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    func goToLogin() {
        self.performSegueWithIdentifier("loginView", sender: self);
    }
    
    func displaySuccessAlertMessage(alertMessage:String) {
        let alertView: SIAlertView = SIAlertView(title: "Success", andMessage: alertMessage)
        alertView.addButtonWithTitle("Let's go!", type: SIAlertViewButtonType.Default, handler: { action in
            self.goToLogin()
        })
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    // Used for accepting terms of service
    func getWifiAddress(completionHandler: (String?, NSError?) -> ()) -> () {
        Alamofire.request(.GET, "https://api.ipify.org").responseString { response in
            // print(response.request) // original URL request
            // print(response.response?.statusCode) // URL response
            // print(response.data) // server data
            // print(response.result) // result of response serialization
            
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let response = value
                    // print("SUCCESS! Response: \(response)")
                    let address = response
                    completionHandler(address, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
                // print("failed to get IP")
                // print(error)
            }
            
        }
        // print("end of func")
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
                presentationSegue.formSheetPresentationController.contentViewCornerRadius = 8
                presentationSegue.formSheetPresentationController.interactivePanGestureDissmisalDirection = .All;
                
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