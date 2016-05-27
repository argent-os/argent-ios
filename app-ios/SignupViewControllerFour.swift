
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift
import TextFieldEffects
import JGProgressHUD
import UIColor_Hex_Swift
import BEMCheckBox
import MZAppearance
import MZFormSheetPresentationController
import JSSAlertView
import StepSlider
import OnePasswordExtension
import CWStatusBarNotification

class SignupViewControllerFour: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var agreementButton: UIButton!

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var switchTermsAndPrivacy: BEMCheckBox = BEMCheckBox(frame: CGRectMake(0, 0, 50, 50))

    let userPassword = KeychainSwift().get("userPassword")!

    // Keychain
    let userFirstName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")!
    let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")!
    let userUsername = NSUserDefaults.standardUserDefaults().stringForKey("userUsername")!
    let userEmail = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")!
    let userPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("userPhoneNumber")!
    let userLegalEntityType = NSUserDefaults.standardUserDefaults().stringForKey("userLegalEntityType")!
    let userDobDay = NSUserDefaults.standardUserDefaults().stringForKey("userDobDay")!
    let userDobMonth = NSUserDefaults.standardUserDefaults().stringForKey("userDobMonth")!
    let userDobYear = NSUserDefaults.standardUserDefaults().stringForKey("userDobYear")!
    let userCountry = NSUserDefaults.standardUserDefaults().stringForKey("userCountry")!
    
    override func viewDidAppear(animated: Bool) {

        let stepButton = UIBarButtonItem(title: "4/4", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor.lightGrayColor()
            ], forState: .Normal)
        
        self.finishButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            self.finishButton.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
        self.view.backgroundColor = UIColor.offWhite()

        agreementButton.titleLabel?.textAlignment = NSTextAlignment.Center

        //        print("user first name", userFirstName)
        //        print("user last name", userLastName)
        //        print("user username", userUsername)
        //        print("user email", userEmail)
        //        print("user phone", userPhoneNumber)
        //        print(userCountry)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let stepper = StepSlider()
        stepper.frame = CGRect(x: 30, y: 65, width: screenWidth-60, height: 15)
        stepper.index = 3
        stepper.trackColor = UIColor.groupTableViewBackgroundColor()
        stepper.trackHeight = 2
        stepper.trackCircleRadius = 3
        stepper.sliderCircleColor = UIColor.slateBlue()
        stepper.sliderCircleRadius = 3
        stepper.maxCount = 4
        stepper.tintColor = UIColor.slateBlue()
        stepper.backgroundColor = UIColor.clearColor()
        // self.view.addSubview(stepper)
        
        // Set checkbox animation
        switchTermsAndPrivacy.onAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.offAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.onCheckColor = UIColor.mediumBlue()
        switchTermsAndPrivacy.onTintColor = UIColor.darkBlue()
        switchTermsAndPrivacy.frame.origin.y = screenHeight-300 // 250 from bottom
        switchTermsAndPrivacy.frame.origin.x = (self.view.bounds.size.width - switchTermsAndPrivacy.frame.size.width) / 2.0
        self.view!.addSubview(switchTermsAndPrivacy)

        finishButton.layer.cornerRadius = 0
        finishButton.backgroundColor = UIColor.mediumBlue()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.mediumBlue()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Accept Terms & Privacy")
        navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
        navBar.setItems([navItem], animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.showInView(self.view!)
        
        if(self.switchTermsAndPrivacy.on.boolValue == false) {
            // Display error if terms of service and privacy policy not accepted
            displayDefaultErrorAlertMessage("Terms of Service and Privacy Policy were not accepted, could not create account");
            HUD.dismiss()
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
                
                var dobJSON: [String: AnyObject] = [ "day": Int(self.userDobDay)!, "month": Int(self.userDobMonth)!, "year": Int(self.userDobYear)! ]
                let dobNSDict = dobJSON as NSDictionary //no error message
                
                var userDeviceToken: String {
                    if let userDeviceToken = KeychainSwift().get("user_device_token_ios") {
                        return userDeviceToken
                    }
                    return ""
                }

                let parameters : [String : AnyObject] = [
                    "first_name":self.userFirstName,
                    "last_name":self.userLastName,
                    "username":self.userUsername,
                    "country":self.userCountry,
                    "email":self.userEmail,
                    "phone_number":self.userPhoneNumber,
                    "tos_acceptance" : tosNSDict,
                    "dob" : dobNSDict,
                    "legal_entity_type": self.userLegalEntityType,
                    "password": self.userPassword,
                    "device_token_ios": userDeviceToken
                ]
                Alamofire.request(.POST, API_URL + "/v1/register", parameters: parameters, encoding:.JSON)
                    .responseJSON { response in
                        if(response.response?.statusCode == 200) {
                            HUD.dismissAfterDelay(3)
                        } else {
                            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                            HUD.dismissAfterDelay(3)
                        }
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                
                                self.displayOnePasswordAlert()
                                
                                // potentially use completionHandler/closure in future
                                let msg = json["message"].stringValue
                                if msg != "" {
                                    HUD.textLabel.text = String(json["message"])
                                }
                            }
                        case .Failure(let error):
                            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                            print(error.userInfo[NSUnderlyingErrorKey]?.localizedDescription)
                            HUD.textLabel.text = error.userInfo[NSUnderlyingErrorKey]?.localizedDescription
                            HUD.dismissAfterDelay(3)
                            break
                        }
                }
                
            } else {
                HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                HUD.textLabel.text = "Registration Error, please check your network connection or date/time settings are correct."
                HUD.dismissAfterDelay(10)
            }
        }
    }
    
    func saveToOnePassword(username: String, password: String, first_name: String, last_name: String) {
        // save credentials to 1Password
        if OnePasswordExtension.sharedExtension().isAppExtensionAvailable() {
            let newLoginDetails:[String: AnyObject] = [
                AppExtensionTitleKey: APP_NAME,
                AppExtensionUsernameKey: username,
                AppExtensionPasswordKey: password,
                AppExtensionNotesKey: "Saved with the " + APP_NAME + " app",
                AppExtensionSectionTitleKey: APP_NAME + " Browser",
                AppExtensionFieldsKey: [
                    "firstname" : first_name,
                    "lastname" : last_name
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
                        self.goToAuth()
                    }
                    self.goToAuth()
                    return
                }
                self.goToAuth()
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
                    self.goToAuth()
                })
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Get 1Password", style: .Default) { (action) in UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/app/1password-password-manager/id568903335")!)
                }
                
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.saveToOnePassword(self.userUsername, password: self.userPassword, first_name: self.userFirstName, last_name: self.userLastName)
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "No Thank You", style: .Cancel, handler: { (action: UIAlertAction!) in
            self.goToAuth()
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    func goToAuth() {
        self.presentViewController(AuthViewController(), animated: true, completion: {
            showGlobalNotification("Welcome to " + APP_NAME + "!", duration: 4, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.brandGreen())
        })
    }
    
    func displayDefaultErrorAlertMessage(alertMessage:String) {
        let customIcon:UIImage = UIImage(named: "IconBellLight")! // your custom icon UIImage
        let customColor:UIColor = UIColor.brandRed() // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: alertMessage,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
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
                print(error)
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
                presentationSegue.formSheetPresentationController.contentViewCornerRadius = 10
                presentationSegue.formSheetPresentationController.interactivePanGestureDismissalDirection = .All;
                presentationSegue.formSheetPresentationController.allowDismissByPanningPresentedView = true

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