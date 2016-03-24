//
//  SignupIndividualViewControllerOne.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift
import SVProgressHUD
import SIAlertView

class SignupIndividualViewControllerOne: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let usernameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC2:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        var stepButton = UIBarButtonItem(title: "1/3", style: UIBarButtonItemStyle.Plain, target: nil, action: "")
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGrayColor()
        
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
        SVProgressHUD.show()
        
        addToolbarButton()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor(rgba: "#38a4f9")
        continueButton.backgroundColor = UIColor(rgba: "#38a4f9")
        
        // Programatically set the input fields
        usernameTextField.tag = 123
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        usernameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.placeholder = "Username"
        usernameTextField.placeholderColor = UIColor.grayColor()
        usernameTextField.textColor = UIColor.grayColor()
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        usernameTextField.keyboardType = UIKeyboardType.Default
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        usernameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        usernameTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        usernameTextField.frame.origin.x = (self.view.bounds.size.width - usernameTextField.frame.size.width) / 2.0
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(usernameTextField)
        
        emailTextField.tag = 124
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.borderActiveColor = UIColor(rgba: "#FFF")
        emailTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Email Address"
        emailTextField.placeholderColor = UIColor.grayColor()
        emailTextField.textColor = UIColor.grayColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        emailTextField.frame.origin.x = (self.view.bounds.size.width - emailTextField.frame.size.width) / 2.0
        emailTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(emailTextField)
        
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
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
        usernameTextField.inputAccessoryView=sendToolbar
        emailTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        var x = performValidation()
        if x == true {
            performSegueWithIdentifier("VC2", sender: sender)
        }
    }
    
    // Check for valid email
    func isValidEmail(emailStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailStr)
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
    
    func isOnlyNumeral(phoneNumber: String) -> Bool {
        var isValid = true
        let name = phoneNumber as NSString
        let nameSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ- ")
        let set = nameSet.invertedSet
        let range = name.rangeOfCharacterFromSet(set)
        let isInvalidName = range.location != NSNotFound
        if(isInvalidName) {
            isValid = false
        }
        return true
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        var alertView: SIAlertView = SIAlertView(title: "Error", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    func performValidation() -> Bool {
        // Username, email, and phone validation
        if(!isValidEmail(emailTextField.text!)) {
            displayErrorAlertMessage("Email is not valid")
            return false
        } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Username and email fields cannot be empty")
            return false
        } else {
            NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        return true
    }
    
    // VALIDATION
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if(identifier == "VC2") {
            // Username, email, and phone validation
            if(!isValidEmail(emailTextField.text!)) {
                displayErrorAlertMessage("Email is not valid")
                return false
            } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Username and email fields cannot be empty")
                return false
            } else {
                NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
                NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
                NSUserDefaults.standardUserDefaults().synchronize();
            }
            return true
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}