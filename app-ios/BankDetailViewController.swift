//
//  DetailViewController.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit
import TextFieldEffects
import SIAlertView

class DetailViewController: UIViewController {
    
    var color: UIColor?
    var logo: String?
    var bankLogoImage: UIImage? = nil
    let idTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.becomeFirstResponder()
    
        print("color is", color)
        view.backgroundColor = color
        
        addToolbarButton()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let bankLogo = logo
        let bankImage = UIImage(named: bankLogo!)
        let bankLogoImageView = UIImageView(image: bankImage!)
        
        bankLogoImageView.frame.origin.y = screenHeight*0.10 // 10 down from the top
        bankLogoImageView.frame.origin.x = (self.view.bounds.size.width - screenWidth) / 2.0
        view.addSubview(bankLogoImageView)
        
        // Programatically set the input fields
        idTextField.tag = 89
        idTextField.textAlignment = NSTextAlignment.Center
        idTextField.borderActiveColor = UIColor(rgba: "#FFF8")
        idTextField.borderInactiveColor = UIColor(rgba: "#FFF9") // color with alpha
        idTextField.backgroundColor = UIColor.clearColor()
        idTextField.placeholder = "Bank Account ID"
        idTextField.placeholderColor = UIColor.whiteColor()
        idTextField.textColor = UIColor.whiteColor()
        idTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        idTextField.autocorrectionType = UITextAutocorrectionType.No
        idTextField.keyboardType = UIKeyboardType.EmailAddress
        idTextField.returnKeyType = UIReturnKeyType.Next
        idTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        idTextField.frame.origin.y = screenHeight*0.25 // 25 down from the top
        idTextField.frame.origin.x = (self.view.bounds.size.width - idTextField.frame.size.width) / 2.0
        idTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(idTextField)
        
        passwordTextField.tag = 90
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.borderActiveColor = UIColor(rgba: "#FFF8")
        passwordTextField.borderInactiveColor = UIColor(rgba: "#FFF9") // color with alpha
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderColor = UIColor.whiteColor()
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.keyboardType = UIKeyboardType.Default
        passwordTextField.secureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.frame.origin.y = screenHeight*0.35 // 25 down from the top
        passwordTextField.frame.origin.x = (self.view.bounds.size.width - passwordTextField.frame.size.width) / 2.0
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(passwordTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "bankListView") {
            print("going to bank list view")
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func nextStep(sender: AnyObject) {
        // Function for toolbar button
        let x = performValidation()
        if x == true {
            self.performSegueWithIdentifier("VC2", sender: sender)
        }
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Connect to Bank", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DetailViewController.login(_:)))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        idTextField.inputAccessoryView=sendToolbar
        passwordTextField.inputAccessoryView=sendToolbar
    }
    
    func login(sender: AnyObject) {
        // Function for toolbar button
        print("logging in")
//        let x = performValidation()
//        if x == true {
//            self.performSegueWithIdentifier("authBank", sender: sender)
//        }
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
        let alertView: SIAlertView = SIAlertView(title: "Error", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    func performValidation() -> Bool {
        if(idTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("First name cannot be empty")
            return false
        } else if(passwordTextField.text?.characters.count < 1) {
            displayErrorAlertMessage("Last name cannot be empty")
            return false
        }
        return true
    }

}