//
//  SignupViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import SVProgressHUD
import TextFieldEffects
import UIColor_Hex_Swift
import MZAppearance
import MZFormSheetPresentationController

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    let usernameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let repeatPasswordTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))

    @IBOutlet weak var blurView: UIView!
    override func viewDidLoad() {

        // Border radius on uiview
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        
        super.viewDidLoad()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        usernameTextField.tag = 0
        usernameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        usernameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.placeholder = "Username"
        usernameTextField.placeholderColor = UIColor.whiteColor()
        usernameTextField.textColor = UIColor.whiteColor()
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        usernameTextField.keyboardType = UIKeyboardType.Default
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        usernameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        usernameTextField.frame.origin.y = screenHeight*0.25 // 25 down from the top
        usernameTextField.frame.origin.x = (self.view.bounds.size.width - usernameTextField.frame.size.width) / 2.0
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(usernameTextField)
        
        emailTextField.tag = 1
        emailTextField.borderActiveColor = UIColor(rgba: "#FFF")
        emailTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Email"
        emailTextField.placeholderColor = UIColor.whiteColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.frame.origin.y = screenHeight*0.35 // 25 down from the top
        emailTextField.frame.origin.x = (self.view.bounds.size.width - emailTextField.frame.size.width) / 2.0
        emailTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(emailTextField)
        
        passwordTextField.tag = 2
        passwordTextField.borderActiveColor = UIColor(rgba: "#FFF")
        passwordTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderColor = UIColor.whiteColor()
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.secureTextEntry = true
        passwordTextField.frame.origin.y = screenHeight*0.45 // 25 down from the top
        passwordTextField.frame.origin.x = (self.view.bounds.size.width - passwordTextField.frame.size.width) / 2.0
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(passwordTextField)
        
        repeatPasswordTextField.tag = 3
        repeatPasswordTextField.borderActiveColor = UIColor(rgba: "#FFF")
        repeatPasswordTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        repeatPasswordTextField.backgroundColor = UIColor.clearColor()
        repeatPasswordTextField.placeholder = "Repeat Password"
        repeatPasswordTextField.placeholderColor = UIColor.whiteColor()
        repeatPasswordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        repeatPasswordTextField.textColor = UIColor.whiteColor()
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Next
        repeatPasswordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        repeatPasswordTextField.secureTextEntry = true
        repeatPasswordTextField.frame.origin.y = screenHeight*0.55 // 25 down from the top
        repeatPasswordTextField.frame.origin.x = (self.view.bounds.size.width - repeatPasswordTextField.frame.size.width) / 2.0
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Join
        view.addSubview(repeatPasswordTextField)
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text;
        let repeatPassword = repeatPasswordTextField.text

        SVProgressHUD.show()

        // check for empty fields
        if(username!.isEmpty || email!.isEmpty || password!.isEmpty || repeatPassword!.isEmpty) {
            // display alert message
            displayErrorAlertMessage("All fields are required");
            SVProgressHUD.dismiss()
            self.dismissKeyboard()
            return;
        }
        
        if(password != repeatPassword) {
            // display alert
            displayErrorAlertMessage("Passwords do not match");
            SVProgressHUD.dismiss()
            self.dismissKeyboard()
            return;
        }
        
        
        if(!isValidEmail(email!)) {
            // display alert
            displayErrorAlertMessage("Email is not valid");
            SVProgressHUD.dismiss()
            self.dismissKeyboard()
            return;
        }

        // Set keychain username and password for PayKloud
        
        
        Alamofire.request(.POST, apiUrl + "/v1/register", parameters: [
            "username":username!,
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .responseJSON { response in
                //print(response.request) // original URL request
                //print(response.response?.statusCode) // URL response
                //print(response.data) // server data
                //print(response.result) // result of response serialization
                
                if(response.response?.statusCode == 200) {
                    // Login is successful
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    SVProgressHUD.show()

                    // go to main view
                    self.performSegueWithIdentifier("loginView", sender: self);

                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                         print("Response: \(json)")
                        // assign userData to self, access globally
                        print("register success")
                    }
                case .Failure(let error):
                    self.dismissKeyboard()
                    print(error)
                }
        }

        dismissKeyboard()
        SVProgressHUD.show()
        displaySuccessAlertMessage("Registration Successful!  You can now login.")
        self.performSegueWithIdentifier("loginView", sender: self);

    }

    
    func displayErrorAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    func displaySuccessAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Success", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    // Allow use of next and join on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag: Int = textField.tag + 1
        
        print(nextTag)
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            self.registerButtonTapped(self)
            textField.resignFirstResponder()
            dismissKeyboard()
            return true
        }
        
        return false
        
    }
    
    // Check for valid email
    func isValidEmail(emailStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailStr)
    }
    
    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "presentModal" {
                let presentationSegue = segue as! MZFormSheetPresentationViewControllerSegue
                presentationSegue.formSheetPresentationController.presentationController?.shouldApplyBackgroundBlurEffect = true
                presentationSegue.formSheetPresentationController.presentationController?.shouldUseMotionEffect = true
                presentationSegue.formSheetPresentationController.presentationController?.contentViewSize = CGSizeMake(300, 250)
                presentationSegue.formSheetPresentationController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
                presentationSegue.formSheetPresentationController.presentationController?.containerView?.sizeToFit()
                presentationSegue.formSheetPresentationController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
//                presentationSegue.formSheetPresentationController.interactivePanGestureDissmisalDirection = MZFormSheetPanGestureDismissDirection.All

                // Blur will be applied to all MZFormSheetPresentationControllers by default
                MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
                
                presentationSegue.formSheetPresentationController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.Fade
                presentationSegue.formSheetPresentationController.contentViewCornerRadius = 8
                
                let navigationController = presentationSegue.formSheetPresentationController.contentViewController as! UINavigationController
                
                let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
                // This will set to only one instance
                presentedViewController.textFieldBecomeFirstResponder = true
                presentedViewController.passingString1 = "Terms and Conditions"
                presentedViewController.passingString2 = "Privacy Policy"
            }
        }
        
    }

}

