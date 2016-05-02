//
//  SignupViewControllerOne.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift
import JGProgressHUD
import JSSAlertView

class SignupViewControllerTwo: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let usernameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let phoneNumberTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC2:Bool = false
    
    //Changing Status Bar
    override internal func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()

        let stepButton = UIBarButtonItem(title: "2/4", style: UIBarButtonItemStyle.Plain, target: nil, action: Selector(""))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.5)
        
        addToolbarButton()

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
        
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor.mediumBlue()
        scrollView.addSubview(continueButton)

        // Programatically set the input fields
        usernameTextField.tag = 123
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.font = UIFont(name: "Avenir-Light", size: 20)
        usernameTextField.borderActiveColor = UIColor.clearColor()
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
        usernameTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.20, width: 300, height: 50)
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(usernameTextField)
        
        emailTextField.tag = 124
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.font = UIFont(name: "Avenir-Light", size: 20)
        emailTextField.borderActiveColor = UIColor.clearColor()
        emailTextField.borderInactiveColor = UIColor.clearColor() // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Email Address"
        emailTextField.placeholderColor = UIColor.grayColor()
        emailTextField.textColor = UIColor.grayColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        emailTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(emailTextField)
        
        phoneNumberTextField.tag = 125
        phoneNumberTextField.textAlignment = NSTextAlignment.Center
        phoneNumberTextField.font = UIFont(name: "Avenir-Light", size: 20)
        phoneNumberTextField.borderActiveColor = UIColor.clearColor()
        phoneNumberTextField.borderInactiveColor = UIColor.clearColor() // color with alpha
        phoneNumberTextField.backgroundColor = UIColor.clearColor()
        phoneNumberTextField.placeholder = "Phone Number (US Only)"
        phoneNumberTextField.placeholderColor = UIColor.grayColor()
        phoneNumberTextField.textColor = UIColor.grayColor()
        phoneNumberTextField.autocapitalizationType = UITextAutocapitalizationType.None
        phoneNumberTextField.autocorrectionType = UITextAutocorrectionType.No
        phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Next
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        phoneNumberTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.40, width: 300, height: 50)
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(phoneNumberTextField)
        
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
        let navItem = UINavigationItem(title: "Create Your Profile")
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SignupViewControllerTwo.nextStep(_:)))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        usernameTextField.inputAccessoryView=sendToolbar
        emailTextField.inputAccessoryView=sendToolbar
        phoneNumberTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        let x = performValidation()
        if x == true {
            self.performSegueWithIdentifier("VC3", sender: sender)
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
    
    // Format phone number input textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == phoneNumberTextField) {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        return true

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
    
    func performValidation() -> Bool {
        // Username, email, and phone validation
        if(!isValidEmail(emailTextField.text!)) {
            displayErrorAlertMessage("Email is not valid")
            return false
        } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Username and email fields cannot be empty")
            return false
        } else if(!isOnlyNumeral(phoneNumberTextField.text!) || (phoneNumberTextField.text?.characters.count > 0 && phoneNumberTextField.text?.characters.count < 14)) {
            displayErrorAlertMessage("Phone number not valid")
            return false
        } else {
            NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
            NSUserDefaults.standardUserDefaults().setValue(phoneNumberTextField.text!, forKey: "userPhoneNumber")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        return true
    }
    
    // VALIDATION
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if(identifier == "VC3") {
            // Username, email, and phone validation
            if(!isValidEmail(emailTextField.text!)) {
                displayErrorAlertMessage("Email is not valid")
                return false
            } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Username and email fields cannot be empty")
                return false
            } else if(!isOnlyNumeral(phoneNumberTextField.text!) || (phoneNumberTextField.text?.characters.count > 0 && phoneNumberTextField.text?.characters.count < 14)) {
                displayErrorAlertMessage("Phone number not valid")
                return false
            } else {
                NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
                NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
                NSUserDefaults.standardUserDefaults().setValue(phoneNumberTextField.text!, forKey: "userPhoneNumber")
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