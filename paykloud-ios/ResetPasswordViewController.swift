//
//  ResetPasswordViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import SVProgressHUD
import VideoSplashKit
import TextFieldEffects
import UIColor_Hex_Swift

class ResetPasswordViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var closeButton: UIButton!
    
    let emailTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    override func viewDidAppear(animated: Bool) {
        // Dismiss loader
        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss loader
        SVProgressHUD.dismiss()
        
        // Add button to keyboard
        addToolbarButton()
        
        // Focuses view controller on first name text input
        emailTextField.becomeFirstResponder()
        
        // Add action to close button to return to auth view
        closeButton.addTarget(self, action: "goToLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Border radius on uiview
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        
        // Inherit UITextField Delegate, this is used for next and go on keyboard
        emailTextField.delegate = self;
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Tags are 4 and 5 due to signup view textfields taking values 0-3
        emailTextField.tag = 328
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.borderActiveColor = UIColor(rgba: "#FFF7")
        emailTextField.borderInactiveColor = UIColor(rgba: "#FFF4") // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Username or Email"
        emailTextField.placeholderColor = UIColor.whiteColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.frame.origin.y = screenHeight*0.3 // 25 down from the top
        emailTextField.frame.origin.x = (self.view.bounds.size.width - emailTextField.frame.size.width) / 2.0
        emailTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(emailTextField)
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Reset Password", style: UIBarButtonItemStyle.Done, target: self, action: Selector("resetButtonTapped:"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        emailTextField.inputAccessoryView=sendToolbar
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func goToLogin(sender:AnyObject!)
    {
        self.performSegueWithIdentifier("loginView", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let username = emailTextField.text
        SVProgressHUD.showInfoWithStatus("Sending reset link...", maskType: SVProgressHUDMaskType.Gradient)
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            displayAlertMessage("Username/Email not entered");
            return;
        }
        
        Alamofire.request(.POST, apiUrl + "/v1/remindpassword", parameters: [
            "username": username!,
            "email":email!
            ],
            encoding:.JSON)
            .responseJSON { response in
                //print(response.request) // original URL request
                //print(response.response?.statusCode) // URL response
                //print(response.data) // server data
                //print(response.result) // result of response serialization
                
                //print("login pressed")
                if(response.response?.statusCode == 200) {
                    SVProgressHUD.showSuccessWithStatus("Password reset link sent!")
                } else {
                    SVProgressHUD.showErrorWithStatus("An error occured")
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print("User Data: \(userData)")
                        // assign userData to self, access globally
                        userData = json
                        
                        print(json)
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    print(error)
                    self.displayErrorAlertMessage("Failed to remind password, please check username/email is correct");
                }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    func displayAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    
    // Toolbar close input keyboard
    @IBAction func addCloseButtonAction() {
        dismissKeyboard()
    }
    
    // Add close button to ui keyboard toolbar
    func addCloseButtonKeyBoard()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let closeToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        closeToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("addCloseButtonAction"))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        
        closeToolbar.items = items
        closeToolbar.sizeToFit()
        emailTextField.inputAccessoryView=closeToolbar
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
