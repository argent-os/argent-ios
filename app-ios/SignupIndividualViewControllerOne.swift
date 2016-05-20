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
import JSSAlertView

class SignupIndividualViewControllerOne: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var continueButton: UIButton!
    
    let usernameTextField  = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let emailTextField  = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Height not adjusted button bool value
    var alreadyAdjustedVC2:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        let stepButton = UIBarButtonItem(title: "1/3", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = stepButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGrayColor()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFontOfSize(14),
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

        self.view.backgroundColor = UIColor.offWhite()

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
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        
        continueButton.layer.cornerRadius = 0
        continueButton.backgroundColor = UIColor.mediumBlue()
        scrollView.addSubview(continueButton)

        // Programatically set the input fields
        usernameTextField.tag = 123
        usernameTextField.textAlignment = NSTextAlignment.Center
        usernameTextField.font = UIFont.systemFontOfSize(14)
        usernameTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.cornerRadius = 10
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.placeholder = "Username"
        usernameTextField.textColor = UIColor.grayColor()
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
        emailTextField.font = UIFont.systemFontOfSize(14)
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.0).CGColor
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.placeholder = "Email"
        emailTextField.textColor = UIColor.grayColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.Never
        emailTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        emailTextField.returnKeyType = UIReturnKeyType.Next
        scrollView.addSubview(emailTextField)
        
        // Focuses view controller on first name text input
        usernameTextField.becomeFirstResponder()
        
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
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
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName:UIColor.mediumBlue().colorWithAlphaComponent(0.5)
        ]
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Create Your Profile")
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Continue", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SignupIndividualViewControllerOne.nextStep(_:)))
        
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
        let x = performValidation()
        if x == true {
            performSegueWithIdentifier("VC2", sender: sender)
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
        } else {
            NSUserDefaults.standardUserDefaults().setValue(usernameTextField.text!, forKey: "userUsername")
            NSUserDefaults.standardUserDefaults().setValue(emailTextField.text!, forKey: "userEmail")
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