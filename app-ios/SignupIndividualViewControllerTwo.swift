//
//  SignupIndividualViewControllerTwo.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/14/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift
import JGProgressHUD
import KeychainSwift
import JSSAlertView

class SignupIndividualViewControllerTwo: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let passwordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let repeatPasswordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Keychain
    let keychain = KeychainSwift()
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC3:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        passwordTextField.becomeFirstResponder()
        
        var stepButton = UIBarButtonItem(title: "2/3", style: UIBarButtonItemStyle.Plain, target: nil, action: Selector(""))
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayColor()
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            self.continueButton.enabled = true
        }
    }
    
    //Changing Status Bar
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show progress loader on load
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
        addToolbarButton()
        
        // Set screen bounds
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor(rgba: "#38a4f9")
        
        // Programatically set the input fields
        passwordTextField.tag = 234
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.borderActiveColor = UIColor.clearColor()
        passwordTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderColor = UIColor.grayColor()
        passwordTextField.textColor = UIColor.grayColor()
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        passwordTextField.secureTextEntry = true
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.keyboardType = UIKeyboardType.Default
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        passwordTextField.frame.origin.x = (self.view.bounds.size.width - passwordTextField.frame.size.width) / 2.0
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(passwordTextField)
        
        repeatPasswordTextField.tag = 235
        repeatPasswordTextField.textAlignment = NSTextAlignment.Center
        repeatPasswordTextField.borderActiveColor = UIColor.clearColor()
        repeatPasswordTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        repeatPasswordTextField.backgroundColor = UIColor.clearColor()
        repeatPasswordTextField.placeholder = "Repeat Password"
        repeatPasswordTextField.placeholderColor = UIColor.grayColor()
        repeatPasswordTextField.textColor = UIColor.grayColor()
        repeatPasswordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        repeatPasswordTextField.secureTextEntry = true
        repeatPasswordTextField.autocorrectionType = UITextAutocorrectionType.No
        repeatPasswordTextField.keyboardType = UIKeyboardType.EmailAddress
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Next
        repeatPasswordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        repeatPasswordTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        repeatPasswordTextField.frame.origin.x = (self.view.bounds.size.width - repeatPasswordTextField.frame.size.width) / 2.0
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(repeatPasswordTextField)
        
        // Focuses view controller on first name text input
        passwordTextField.becomeFirstResponder()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: Selector("nextStep:"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        passwordTextField.inputAccessoryView=sendToolbar
        repeatPasswordTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        var x = performValidation()
        if x == true {
            performSegueWithIdentifier("finishView", sender: sender)
        }
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
    
    // Allow use of next and join on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: Int = textField.tag + 1
        // print(nextTag)
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    // Checks for password to have at least one uppercase, at least a number, and a minimum length of 6 characters + a maximum of 15.
    func isValidPassword(candidate: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluateWithObject(candidate)
    }
    
    func performValidation() -> Bool {
        if(passwordTextField.text != repeatPasswordTextField.text) {
            // display alert
            displayErrorAlertMessage("Passwords do not match");
            return false
        } else if(passwordTextField.text == "" || repeatPasswordTextField.text == "") {
            // display alert
            displayErrorAlertMessage("Password cannot be empty");
            return false
        } else if(!isValidPassword(passwordTextField.text!)) {
            displayErrorAlertMessage("Password must contain at least 1 capital letter and 1 number, be longer than 6 characters and cannot be more than 15 characters in length");
            return false
        } else {
            keychain.set(passwordTextField.text!, forKey: "userPassword")
        }
        return true
    }
    
    // VALIDATION
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if(identifier == "finishView") {
            if(passwordTextField.text != repeatPasswordTextField.text) {
                // display alert
                displayErrorAlertMessage("Passwords do not match");
                return false
            } else if(passwordTextField.text == "" || repeatPasswordTextField.text == "") {
                // display alert
                displayErrorAlertMessage("Password cannot be empty");
                return false
            } else if(!isValidPassword(passwordTextField.text!)) {
                displayErrorAlertMessage("Password must contain at least 1 capital letter and 1 number, be longer than 6 characters and cannot be more than 15 characters in length");
                return false
            } else {
                keychain.set(passwordTextField.text!, forKey: "userPassword")
            }
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}