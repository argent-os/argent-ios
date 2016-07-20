//
//  SignupViewControllerOne.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import UIKit
import UIColor_Hex_Swift
import StepSlider
import JSSAlertView

class SignupViewControllerOne: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let firstNameTextField  = UITextField()
    let lastNameTextField  = UITextField()
    let businessNameTextField  = UITextField()
    let dobTextField  = UITextField()
    
    var dobDay:String = ""
    var dobMonth:String = ""
    var dobYear:String = ""
    
    var passedValidation:Bool?

    override func viewDidAppear(animated: Bool) {
        
        firstNameTextField.becomeFirstResponder()

        addToolbarButton()

        let stepButton = UIBarButtonItem(title: "1/4", style: UIBarButtonItemStyle.Plain, target: nil, action: Selector(""))
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightBlue()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(14),
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

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        self.view.backgroundColor = UIColor.whiteColor()

        let stepper = StepSlider()
        stepper.frame = CGRect(x: 30, y: 65, width: screenWidth-60, height: 15)
        stepper.index = 0
        stepper.trackColor = UIColor.whiteColor()
        stepper.trackHeight = 2
        stepper.trackCircleRadius = 3
        stepper.sliderCircleColor = UIColor.slateBlue()
        stepper.sliderCircleRadius = 3
        stepper.maxCount = 4
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
        
        // Focuses view controller on first name text input
        firstNameTextField.becomeFirstResponder()
        
        // Tint back button to gray
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        title = ""
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.dobTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor.mediumBlue()
        scrollView.addSubview(continueButton)

        // Programatically set the input fields
        firstNameTextField.tag = 28346
        firstNameTextField.textAlignment = NSTextAlignment.Center
        firstNameTextField.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        firstNameTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.cornerRadius = 10
        firstNameTextField.backgroundColor = UIColor.clearColor()
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.textColor = UIColor.lightBlue()
        firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.No
        firstNameTextField.keyboardType = UIKeyboardType.Default
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        firstNameTextField.clearButtonMode = UITextFieldViewMode.Never
        firstNameTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.10, width: 300, height: 50)
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(firstNameTextField)
        
        lastNameTextField.tag = 28347
        lastNameTextField.textAlignment = NSTextAlignment.Center
        lastNameTextField.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        lastNameTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.cornerRadius = 10
        lastNameTextField.backgroundColor = UIColor.clearColor()
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.textColor = UIColor.lightBlue()
        lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.No
        lastNameTextField.keyboardType = UIKeyboardType.Default
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        lastNameTextField.clearButtonMode = UITextFieldViewMode.Never
        lastNameTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.20, width: 300, height: 50)
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(lastNameTextField)
        
        businessNameTextField.tag = 28348
        businessNameTextField.textAlignment = NSTextAlignment.Center
        businessNameTextField.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
        businessNameTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        businessNameTextField.layer.borderWidth = 1
        businessNameTextField.layer.cornerRadius = 10
        businessNameTextField.backgroundColor = UIColor.clearColor()
        businessNameTextField.placeholder = "Business Name"
        businessNameTextField.textColor = UIColor.lightBlue()
        businessNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        businessNameTextField.autocorrectionType = UITextAutocorrectionType.No
        businessNameTextField.keyboardType = UIKeyboardType.Default
        businessNameTextField.returnKeyType = UIReturnKeyType.Next
        businessNameTextField.clearButtonMode = UITextFieldViewMode.Never
        businessNameTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        businessNameTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(businessNameTextField)

        dobTextField.tag = 28349
        dobTextField.textAlignment = NSTextAlignment.Center
        dobTextField.font = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
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
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor.lightBlue()
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Company / Rep Information")
        navItem.leftBarButtonItem?.tintColor = UIColor.mediumBlue()
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.nextStep(_:)))
        
        UIToolbar.appearance().barTintColor = UIColor.brandGreen()
        UIToolbar.appearance().backgroundColor = UIColor.brandGreen()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(15, weight: UIFontWeightRegular), NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        firstNameTextField.inputAccessoryView=sendToolbar
        lastNameTextField.inputAccessoryView=sendToolbar
        businessNameTextField.inputAccessoryView=sendToolbar
        dobTextField.inputAccessoryView=sendToolbar
    }
    
    func nextStep(sender: AnyObject) {
        // Function for toolbar button
        passedValidation = performValidation()
        if passedValidation == true {
            self.performSegueWithIdentifier("VC2", sender: sender)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VC2" {
            passedValidation = performValidation()
        }
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
    
    func displayErrorAlertMessage(alertMessage:String) {
        let customIcon:UIImage = UIImage(named: "IconBellLight")! // your custom icon UIImage
        let customColor:UIColor = UIColor.brandRed() // base color for the alert
        self.view.endEditing(true)
        let alertView = JSSAlertView().show(
            self,
            title: "",
            text: alertMessage,
            buttonText: "Ok",
            noButtons: false,
            color: customColor,
            iconImage: customIcon)
        alertView.setTextTheme(.Light) // can be .Light or .Dark
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
    
    func performValidation() -> Bool {
        if(firstNameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("First name cannot be empty")
            return false
        } else if(lastNameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Last name cannot be empty")
            return false
        } else if(businessNameTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Company name cannot be empty")
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
            NSUserDefaults.standardUserDefaults().setValue(businessNameTextField.text!, forKey: "userBusinessName")
            NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
            NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
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
            if(firstNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("First name cannot be empty")
                return false
            } else if(lastNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Last name cannot be empty")
                return false
            } else if(businessNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Company name cannot be empty")
                return false
            } else if(dobTextField.text!.characters.count < 10) {
                displayErrorAlertMessage("Company founded date length too short")
                return false
            } else if(dobMonth == "" || dobDay == "" || dobYear == "") {
                displayErrorAlertMessage("Company founded date cannot be empty")
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
                NSUserDefaults.standardUserDefaults().setValue(businessNameTextField.text!, forKey: "userBusinessName")
                NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
                NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
                NSUserDefaults.standardUserDefaults().setValue(dobDay, forKey: "userDobDay")
                NSUserDefaults.standardUserDefaults().setValue(dobMonth, forKey: "userDobMonth")
                NSUserDefaults.standardUserDefaults().setValue(dobYear, forKey: "userDobYear")
                NSUserDefaults.standardUserDefaults().synchronize();
            }
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}