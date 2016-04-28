
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

class SignupViewControllerFour: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var agreementButton: UIButton!

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    var switchTermsAndPrivacy: BEMCheckBox = BEMCheckBox(frame: CGRectMake(0, 0, 50, 50))

    // Keychain
    let userFirstName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")!
    let userLastName = NSUserDefaults.standardUserDefaults().objectForKey("userLastName")!
    let userUsername = NSUserDefaults.standardUserDefaults().stringForKey("userUsername")!
    let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("userEmail")!
    let userPhoneNumber = NSUserDefaults.standardUserDefaults().stringForKey("userPhoneNumber")!
    let userLegalEntityType = NSUserDefaults.standardUserDefaults().stringForKey("userLegalEntityType")!
    let userDobDay = NSUserDefaults.standardUserDefaults().stringForKey("userDobDay")!
    let userDobMonth = NSUserDefaults.standardUserDefaults().stringForKey("userDobMonth")!
    let userDobYear = NSUserDefaults.standardUserDefaults().stringForKey("userDobYear")!
    let userCountry = NSUserDefaults.standardUserDefaults().stringForKey("userCountry")!
    
    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {

        let stepButton = UIBarButtonItem(title: "4/4", style: UIBarButtonItemStyle.Plain, target: nil, action: Selector(""))
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!,
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

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
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
        
        // Set checkbox animation
        switchTermsAndPrivacy.onAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.offAnimationType = BEMAnimationType.OneStroke
        switchTermsAndPrivacy.onCheckColor = UIColor(rgba: "#1aa8f6")
        switchTermsAndPrivacy.onTintColor = UIColor(rgba: "#1aa8f6")
        switchTermsAndPrivacy.frame.origin.y = screenHeight-300 // 250 from bottom
        switchTermsAndPrivacy.frame.origin.x = (self.view.bounds.size.width - switchTermsAndPrivacy.frame.size.width) / 2.0
        self.view!.addSubview(switchTermsAndPrivacy)

        finishButton.layer.cornerRadius = 0
        finishButton.backgroundColor = UIColor.protonBlue()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 47))
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!,
            NSForegroundColorAttributeName:UIColor.darkGrayColor()
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Accept Terms & Privacy")
        navItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
        navBar.setItems([navItem], animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        print("finish button tapped")
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
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
                
                var dobContent: [String: AnyObject] = [ "day": Int(self.userDobDay)!, "month": Int(self.userDobMonth)!, "year": Int(self.userDobYear)!] //also works with [ "model" : NSNull()]
                var dobJSON: [String: [String: AnyObject]] = [ "data" : dobContent ]
                let dobNSDict = dobJSON as NSDictionary //no error message
                
                let userPassword = KeychainSwift().get("userPassword")!
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
                            print("register success")
                            HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                            HUD.dismissAfterDelay(3)
                            HUD.textLabel.text = "Registration success! You can now login."
                            print("response 200 success")
                            // go to main view
                            Timeout(2) {
                                self.performSegueWithIdentifier("loginView", sender: self)
                            }
                        } else {
                            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                            HUD.dismissAfterDelay(3)
                            print("failed to signup")
                        }
                        
                        switch response.result {
                        case .Success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                // potentially use completionHandler/closure in future
                                print("Response: \(json)")
                                let msg = json["message"].stringValue
                                if msg != "" {
                                    HUD.textLabel.text = String(json["message"])
                                }
                                // assign userData to self, access globally
                            }
                        case .Failure(let error):
                            print("failed to signup", error)
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
        
        
        // TODO: Set keychain username and password
        
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let customIcon:UIImage = UIImage(named: "ic_close_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor.protonBlue() // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: alertMessage,
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    func displayDefaultErrorAlertMessage(alertMessage:String) {
        let customIcon:UIImage = UIImage(named: "ic_close_light")! // your custom icon UIImage
        let customColor:UIColor = UIColor.protonBlue() // base color for the alert
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: alertMessage,
            buttonText: "",
            noButtons: true,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
    }
    
    func goToLogin() {
        self.performSegueWithIdentifier("loginView", sender: self);
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