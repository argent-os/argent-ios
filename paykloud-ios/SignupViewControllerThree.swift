//
//  SignupViewControllerOne.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift
import SVProgressHUD
import KeychainSwift

class SignupViewControllerThree: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let passwordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let repeatPasswordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Keychain
    let keychain = KeychainSwift()
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC3:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            SVProgressHUD.dismiss()
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
        SVProgressHUD.show()

        // Focuses view controller on first name text input
        passwordTextField.becomeFirstResponder()
        
        // Set screen bounds
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.passwordTextField.delegate = self
        self.repeatPasswordTextField.delegate = self
        
        continueButton.layer.cornerRadius = 5
        continueButton.backgroundColor = UIColor(rgba: "#1aa8f6")
        
        // Programatically set the input fields
        passwordTextField.tag = 234
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.borderActiveColor = UIColor(rgba: "#FFF")
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
        repeatPasswordTextField.borderActiveColor = UIColor(rgba: "#FFF")
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    // Adjusts keyboard height to view
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // Check if already adjusted height
        if(alreadyAdjustedVC3 == false) {
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let changeInHeight = (CGRectGetHeight(keyboardFrame) + 2) * (show ? 1 : -1)
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottomConstraint.constant += changeInHeight
            })
            // Already adjusted height so make it true so it doesn't continue adjusting everytime a label is focused
            alreadyAdjustedVC3 = true
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
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
    
    // VALIDATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(passwordTextField.text != repeatPasswordTextField.text) {
            // display alert
            displayErrorAlertMessage("Passwords do not match");
            return;
        } else if(passwordTextField.text == "" || repeatPasswordTextField.text == "") {
            // display alert
            displayErrorAlertMessage("Password cannot be empty");
            return;
        } else if(!isValidPassword(passwordTextField.text!)) {
            displayErrorAlertMessage("Password must contain at least 1 capital letter and 1 number, be longer than 6 characters and cannot be more than 15 characters in length");
        } else {
            keychain.set(passwordTextField.text!, forKey: "userPassword")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}