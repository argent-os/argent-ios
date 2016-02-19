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

class SignupViewControllerOne: UIViewController, UITextFieldDelegate {

    // WHEN NAVIGATING TO A NAVIGATION CONTROLLER USE SEGUE SHOW NOT MODAL!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let firstNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let lastNameTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Height not adjusted button bool value
    var adjustingHeightBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        nextButton.layer.cornerRadius = 5
        // Programatically set the input fields
        firstNameTextField.tag = 0
        firstNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        firstNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        firstNameTextField.backgroundColor = UIColor.clearColor()
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.placeholderColor = UIColor.whiteColor()
        firstNameTextField.textColor = UIColor.whiteColor()
        firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.No
        firstNameTextField.keyboardType = UIKeyboardType.Default
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        firstNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        firstNameTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        firstNameTextField.frame.origin.x = (self.view.bounds.size.width - firstNameTextField.frame.size.width) / 2.0
        firstNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(firstNameTextField)
        
        lastNameTextField.tag = 0
        lastNameTextField.borderActiveColor = UIColor(rgba: "#FFF")
        lastNameTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        lastNameTextField.backgroundColor = UIColor.clearColor()
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.placeholderColor = UIColor.whiteColor()
        lastNameTextField.textColor = UIColor.whiteColor()
        lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.None
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.No
        lastNameTextField.keyboardType = UIKeyboardType.Default
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        lastNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        lastNameTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        lastNameTextField.frame.origin.x = (self.view.bounds.size.width - lastNameTextField.frame.size.width) / 2.0
        lastNameTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(lastNameTextField)
        
        // Focuses view controller on first name text input
        firstNameTextField.becomeFirstResponder()

        // Close button to return to login
        let closeButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: .Plain, target: self, action: "returnToLogin")
        navigationItem.leftBarButtonItem = closeButton
        closeButton.tintColor = UIColor.whiteColor()
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
        let viewController:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(viewController, animated: true, completion: nil)

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
        print("keyboard will hide")
//        adjustingHeight(false, notification: notification)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("view will disappear")

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began, ending editing")
//        self.view.endEditing(true)
    }

}