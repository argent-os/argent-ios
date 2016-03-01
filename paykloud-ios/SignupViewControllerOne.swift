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

class SignupViewControllerOne: UIViewController, UITextFieldDelegate {

    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let firstNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let lastNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let dobTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    var dobDay:String = ""
    var dobMonth:String = ""
    var dobYear:String = ""
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC1:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        firstNameTextField.becomeFirstResponder()
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        Timeout(0.3) {
            SVProgressHUD.dismiss()
            self.continueButton.enabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Tint back button to gray
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
        title = ""
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.dobTextField.delegate = self
        
        continueButton.layer.cornerRadius = 5
        continueButton.backgroundColor = UIColor(rgba: "#1aa8f6")

        // Programatically set the input fields
        firstNameTextField.tag = 89
        firstNameTextField.textAlignment = NSTextAlignment.Center
        firstNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        firstNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        firstNameTextField.backgroundColor = UIColor.clearColor()
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.placeholderColor = UIColor.grayColor()
        firstNameTextField.textColor = UIColor.grayColor()
        firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.No
        firstNameTextField.keyboardType = UIKeyboardType.Default
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        firstNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        firstNameTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        firstNameTextField.frame.origin.x = (self.view.bounds.size.width - firstNameTextField.frame.size.width) / 2.0
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(firstNameTextField)
        
        lastNameTextField.tag = 90
        lastNameTextField.textAlignment = NSTextAlignment.Center
        lastNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        lastNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        lastNameTextField.backgroundColor = UIColor.clearColor()
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.placeholderColor = UIColor.grayColor()
        lastNameTextField.textColor = UIColor.grayColor()
        lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.No
        lastNameTextField.keyboardType = UIKeyboardType.Default
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        lastNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        lastNameTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        lastNameTextField.frame.origin.x = (self.view.bounds.size.width - lastNameTextField.frame.size.width) / 2.0
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(lastNameTextField)

        dobTextField.tag = 91
        dobTextField.textAlignment = NSTextAlignment.Center
        dobTextField.borderActiveColor = UIColor(rgba: "#FFF")
        dobTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        dobTextField.backgroundColor = UIColor.clearColor()
        dobTextField.placeholder = "Date of Birth - MM/DD/YYYY"
        dobTextField.keyboardType = UIKeyboardType.NumberPad
        dobTextField.placeholderColor = UIColor.grayColor()
        dobTextField.textColor = UIColor.grayColor()
        dobTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        dobTextField.frame.origin.y = screenHeight*0.40 // 25 down from the top
        dobTextField.frame.origin.x = (self.view.bounds.size.width - dobTextField.frame.size.width) / 2.0
        view.addSubview(dobTextField)
        
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
        if(alreadyAdjustedVC1 == false) {
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let changeInHeight = (CGRectGetHeight(keyboardFrame) + 2) * (show ? 1 : -1)
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottomConstraint.constant += changeInHeight
            })
            // Already adjusted height so make it true so it doesn't continue adjusting everytime a label is focused
            alreadyAdjustedVC1 = true
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
    
    func displayErrorAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    // Format dob number input textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == dobTextField) {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            
            if length == 0 || length > 8 || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 8) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if (length - index) > 2
            {
                dobMonth = decimalStr.substringWithRange(NSMakeRange(index, 2))
                formattedString.appendFormat("%@/", dobMonth)
//                print("dob month", dobMonth)
                index += 2
            }
            if length - index > 2
            {
                dobDay = decimalStr.substringWithRange(NSMakeRange(index, 2))
                formattedString.appendFormat("%@/", dobDay)
//                print("dob day", dobDay)
                index += 2
            }
            if length - index >= 4
            {
                dobYear = decimalStr.substringWithRange(NSMakeRange(index, 4))
//                print("dob year", dobYear)
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        return true
        
    }
    
    // VALIDATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "VC2") {
            if(firstNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("First name cannot be empty")
            } else if(lastNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Last name cannot be empty")
            } else if(Int(dobMonth) > 12 || Int(dobMonth) == 0 || Int(dobDay) == 0 || Int(dobDay) > 31 || Int(dobYear) > 2006 || Int(dobYear) < 1914) {
                displayErrorAlertMessage("Month cannot be greater than 12 or equal to zero. Day cannot be greater than 31 or equal to zero, year cannot be less than 1914 or greater than 2006")
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 29 && (Int(dobYear)! % 4) == 0 ) {
                displayErrorAlertMessage("Leap years do not have more than 29 days")
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 28 && (Int(dobYear)! % 4) != 0 ) {
                displayErrorAlertMessage("Invalid entry, not a leap year")
            } else if((Int(dobMonth) == 02 && Int(dobDay) > 30) || (Int(dobMonth) == 04 && Int(dobDay) > 30) || (Int(dobMonth) == 06 && Int(dobDay) > 30) || (Int(dobMonth) == 09 && Int(dobDay) > 30) || (Int(dobMonth) == 11 && Int(dobDay) > 30)) {
                displayErrorAlertMessage("The entered month does not have 31 days")
            } else {
                print(firstNameTextField.text!)
                NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
                NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
                NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
                NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
                NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
                NSUserDefaults.standardUserDefaults().synchronize();
                
            }
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