//
//  SignupIndividualViewControllerTwo.swift
//  argent-ios
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

class SignupIndividualViewControllerTwo: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
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
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "Avenir-Light", size: 16)!,
            NSForegroundColorAttributeName:UIColor.lightGrayColor()
            ], forState: .Normal)
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            self.continueButton.enabled = true
        }
    }
    
    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show progress loader on load
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
        addToolbarButton()
        
        // Set screen bounds
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let scrollView:UIScrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        scrollView.contentSize = CGSizeMake(screenWidth, 550)
        self.view!.addSubview(scrollView)
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor.mediumBlue()
        scrollView.addSubview(continueButton)

        // Programatically set the input fields
        passwordTextField.tag = 234
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.font = UIFont(name: "Avenir-Light", size: 20)
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
        passwordTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.20, width: 300, height: 50)
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(passwordTextField)
        
        repeatPasswordTextField.tag = 235
        repeatPasswordTextField.textAlignment = NSTextAlignment.Center
        repeatPasswordTextField.font = UIFont(name: "Avenir-Light", size: 20)
        repeatPasswordTextField.borderActiveColor = UIColor.clearColor()
        repeatPasswordTextField.borderInactiveColor = UIColor.clearColor() // color with alpha
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
        repeatPasswordTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        repeatPasswordTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(repeatPasswordTextField)
        
        // Focuses view controller on first name text input
        passwordTextField.becomeFirstResponder()
        
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
        let navItem = UINavigationItem(title: "Create a Password")
        navItem.leftBarButtonItem?.tintColor = UIColor.darkGrayColor()
        navBar.setItems([navItem], animated: true)
        
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
        let customColor:UIColor = UIColor.mediumBlue() // base color for the alert
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