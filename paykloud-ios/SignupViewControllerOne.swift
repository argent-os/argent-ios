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
        
        // Inherit UITextField Delegate, this is used for next and join on keyboard
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
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

        // Close button to return to login
        let closeButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: .Plain, target: self, action: "returnToLogin")
        navigationItem.leftBarButtonItem = closeButton
        closeButton.tintColor = UIColor.grayColor()
        title = ""

        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    // Return to login func
    func returnToLogin() {
        self.performSegueWithIdentifier("loginView", sender: self);
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
    
    // VALIDATION
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "VC2") {
            if(firstNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("First name cannot be empty")
            }
            if(lastNameTextField.text?.characters.count < 1) {
                displayErrorAlertMessage("Last name cannot be empty")
            } else {
                NSUserDefaults.standardUserDefaults().setValue(firstNameTextField.text!, forKey: "userFirstName")
                NSUserDefaults.standardUserDefaults().setValue(lastNameTextField.text!, forKey: "userLastName")
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