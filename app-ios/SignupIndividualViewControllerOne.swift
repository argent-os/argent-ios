//
//  SignupIndividualViewControllerOne.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
import StepSlider
import SCLAlertView

class SignupIndividualViewControllerOne: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let usernameTextField  = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField  = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let dobTextField  = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    var dobDay:String = ""
    var dobMonth:String = ""
    var dobYear:String = ""
    
    var passedValidation:Bool? = false

    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        let stepButton = UIBarButtonItem(title: "1/3", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightBlue()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
            ], forState: .Normal)
        
        self.continueButton.enabled = false
        // Allow continue to be clicked
        let _ = Timeout(0.3) {
            self.continueButton.enabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()

        addToolbarButton()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let stepper = StepSlider()
        stepper.frame = CGRect(x: 30, y: 65, width: screenWidth-60, height: 15)
        stepper.index = 0
        stepper.trackColor = UIColor.whiteColor()
        stepper.trackHeight = 2
        stepper.trackCircleRadius = 3
        stepper.sliderCircleColor = UIColor.slateBlue()
        stepper.sliderCircleRadius = 3
        stepper.maxCount = 3
        stepper.tintColor = UIColor.slateBlue()
        stepper.backgroundColor = UIColor.clearColor()
        // self.view.addSubview(stepper)
        
        let scrollView:UIScrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        scrollView.contentSize = CGSizeMake(screenWidth, 550)
        self.view!.addSubview(scrollView)
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard and dob formatting
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.dobTextField.delegate = self

        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor.brandGreen()
        scrollView.addSubview(continueButton)

        // Programatically set the input fields
        usernameTextField.tag = 123
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.font = UIFont(name: "SFUIText-Regular", size: 17)!
        usernameTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.placeholder = "Username"
        usernameTextField.textColor = UIColor.lightBlue()
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        usernameTextField.keyboardType = UIKeyboardType.Default
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        usernameTextField.clearButtonMode = UITextFieldViewMode.Never
        usernameTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.20, width: 300, height: 50)
        usernameTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(usernameTextField)
        
        emailTextField.tag = 124
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.font = UIFont(name: "SFUIText-Regular", size: 17)!
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.placeholder = "Email"
        emailTextField.textColor = UIColor.lightBlue()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.Never
        emailTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        emailTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(emailTextField)
        
        dobTextField.tag = 125
        dobTextField.textAlignment = NSTextAlignment.Center
        dobTextField.font = UIFont(name: "SFUIText-Regular", size: 17)!
        dobTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        dobTextField.layer.borderWidth = 1
        dobTextField.layer.cornerRadius = 10
        dobTextField.backgroundColor = UIColor.clearColor()
        dobTextField.placeholder = "Date of Birth | MM/DD/YYYY"
        dobTextField.keyboardType = UIKeyboardType.NumberPad
        dobTextField.textColor = UIColor.lightBlue()
        dobTextField.clearButtonMode = UITextFieldViewMode.Never
        dobTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.40, width: 300, height: 50)
        scrollView.addSubview(dobTextField)
        
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
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
            NSFontAttributeName: UIFont(name: "SFUIText-Regular", size: 17)!,
            NSForegroundColorAttributeName:UIColor.lightBlue()
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Create Your Profile")
        navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
        navBar.setItems([navItem], animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    // Add send toolbar
    func addToolbarButton() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SignupIndividualViewControllerOne.nextStep(_:)))
        
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "SFUIText-Regular", size: 15)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ], forState: .Normal)
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        usernameTextField.inputAccessoryView=sendToolbar
        emailTextField.inputAccessoryView=sendToolbar
        dobTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        passedValidation = performValidation()
        if passedValidation == true {
            performSegueWithIdentifier("VC2", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VC2" {
            passedValidation = performValidation()
        }
    }
    
    // Check for valid email
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emailStr)
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
        showAlert(.Error, title: "Error", msg: alertMessage)
        self.view.endEditing(true)
    }
    
    func performValidation() -> Bool {
        // Username, email, and phone validation
        if(!isValidEmail(emailTextField.text!)) {
            displayErrorAlertMessage("Email is not valid")
            return false
        } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Username and email fields cannot be empty")
            return false
        } else if(dobTextField.text!.characters.count < 10) {
            displayErrorAlertMessage("Date of birth length too short")
            return false
        } else if(dobMonth == "" || dobDay == "" || dobYear == "") {
            displayErrorAlertMessage("Date of birth cannot be empty")
            return false
        } else if(Int(dobMonth) > 12 || Int(dobMonth) == 0 || Int(dobDay) == 0 || Int(dobDay) > 31 || Int(dobYear) > 2002 || Int(dobYear) < 1914) {
            displayErrorAlertMessage("Month cannot be greater than 12 or equal to zero. Day cannot be greater than 31 or equal to zero, year cannot be less than 1914 or greater than 2002")
            return false
        } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 29 && (Int(dobYear)! % 4) == 0 ) {
            displayErrorAlertMessage("Leap years do not have more than 29 days")
            return false
        } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 28 && (Int(dobYear)! % 4) != 0 ) {
            displayErrorAlertMessage("Invalid entry, not a leap year")
            return false
        } else if((Int(dobMonth) == 02 && Int(dobDay) > 30) || (Int(dobMonth) == 04 && Int(dobDay) > 30) || (Int(dobMonth) == 06 && Int(dobDay) > 30) || (Int(dobMonth) == 09 && Int(dobDay) > 30) || (Int(dobMonth) == 11 && Int(dobDay) > 30)) {
            displayErrorAlertMessage("The entered month does not have 31 days")
            return false
        } else {
            NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
            NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
            NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
            NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        return true
    }
    
    // VALIDATION
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if(identifier == "VC2") {
            // Username, email, and phone validation
            if(!isValidEmail(emailTextField.text!)) {
                displayErrorAlertMessage("Email is not valid")
                return false
            } else if(emailTextField.text?.characters.count < 1 || usernameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Username and email fields cannot be empty")
                return false
            } else if(dobTextField.text!.characters.count < 10) {
                displayErrorAlertMessage("Date of birth length too short")
                return false
            } else if(dobMonth == "" || dobDay == "" || dobYear == "") {
                displayErrorAlertMessage("Date of birth cannot be empty")
                return false
            } else if(Int(dobMonth) > 12 || Int(dobMonth) == 0 || Int(dobDay) == 0 || Int(dobDay) > 31 || Int(dobYear) > 2002 || Int(dobYear) < 1914) {
                displayErrorAlertMessage("Month cannot be greater than 12 or equal to zero. Day cannot be greater than 31 or equal to zero, year cannot be less than 1914 or greater than 2002")
                return false
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 29 && (Int(dobYear)! % 4) == 0 ) {
                displayErrorAlertMessage("Leap years do not have more than 29 days")
                return false
            } else if(Int(dobMonth)! == 02 && Int(dobDay)! > 28 && (Int(dobYear)! % 4) != 0 ) {
                displayErrorAlertMessage("Invalid entry, not a leap year")
                return false
            } else if((Int(dobMonth) == 02 && Int(dobDay) > 30) || (Int(dobMonth) == 04 && Int(dobDay) > 30) || (Int(dobMonth) == 06 && Int(dobDay) > 30) || (Int(dobMonth) == 09 && Int(dobDay) > 30) || (Int(dobMonth) == 11 && Int(dobDay) > 30)) {
                displayErrorAlertMessage("The entered month does not have 31 days")
                return false
            } else {
                NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
                NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
                NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
                NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
                NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
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

extension SignupIndividualViewControllerOne {
    // Format dob number input textfield
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == usernameTextField) {
            if string == " " {
                return false
            } else {
                return true
            }
        }
        
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
}