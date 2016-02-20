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

class SignupViewControllerTwo: UIViewController, UITextFieldDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let usernameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let phoneNumberTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Height not adjusted button bool value
    var adjustingHeightBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        
        continueButton.layer.cornerRadius = 5
        continueButton.backgroundColor = UIColor(rgba: "#1e63ef")

        // Programatically set the input fields
        usernameTextField.tag = 123
        usernameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        usernameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.placeholder = "PayKloud Username"
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
        
        phoneNumberTextField.tag = 125
        phoneNumberTextField.borderActiveColor = UIColor(rgba: "#FFF")
        phoneNumberTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        phoneNumberTextField.backgroundColor = UIColor.clearColor()
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.placeholderColor = UIColor.grayColor()
        phoneNumberTextField.textColor = UIColor.grayColor()
        phoneNumberTextField.autocapitalizationType = UITextAutocapitalizationType.None
        phoneNumberTextField.autocorrectionType = UITextAutocorrectionType.No
        phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Next
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        phoneNumberTextField.frame.origin.y = screenHeight*0.40 // 25 down from the top
        phoneNumberTextField.frame.origin.x = (self.view.bounds.size.width - phoneNumberTextField.frame.size.width) / 2.0
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(phoneNumberTextField)
        
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
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
    
    // Adjusts keyboard height to view
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // Check if already adjusted height
        if(adjustingHeightBool == false) {
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let changeInHeight = (CGRectGetHeight(keyboardFrame) + 2) * (show ? 1 : -1)
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottomConstraint.constant += changeInHeight
            })
            // Already adjusted height so make it true so it doesn't continue adjusting everytime a label is focused
            adjustingHeightBool = true
        }
    }
    
    func keyboardWillShow(notification:NSNotification) {
        print("keyboard will show")
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
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
    
    override func viewWillDisappear(animated: Bool) {
        print("view will disappear")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began, ending editing")
                self.view.endEditing(true)
    }
    
}