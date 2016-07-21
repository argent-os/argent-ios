//
//  ResetPasswordViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import TextFieldEffects
import UIColor_Hex_Swift
import CWStatusBarNotification
import Crashlytics

class ResetPasswordViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var closeButton: UIButton!
    
    let emailTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    override func viewDidAppear(animated: Bool) {
        // Dismiss loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background image
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundDashboard"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        // Add button to keyboard
        addToolbarButton()
        
        // Focuses view controller on first name text input
        emailTextField.becomeFirstResponder()
        emailTextField.tintColor = UIColor.whiteColor()
        
        // Add action to close button to return to auth view
        closeButton.addTarget(self, action: #selector(ResetPasswordViewController.goToLogin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        emailTextField.font = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        emailTextField.borderActiveColor = UIColor.clearColor()
        emailTextField.borderInactiveColor = UIColor.clearColor() // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Username or Email"
        emailTextField.placeholderColor = UIColor.whiteColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.frame = CGRect(x: screenWidth/2-150, y: screenHeight*0.30, width: 300, height: 50)
        emailTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(emailTextField)
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResetPasswordViewController.dismissKeyboard))
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Reset Password", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ResetPasswordViewController.resetButtonTapped(_:)))
        
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()

        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont.systemFontOfSize(15, weight: UIFontWeightLight),
            NSForegroundColorAttributeName : UIColor.mediumBlue()
            ], forState: .Normal)
        
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
        
        showGlobalNotification("Sending reset link...", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.skyBlue())
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            showAlert(.Warning, title: "Warning", msg: "Username/Email not entered")
            return;
        }
        
        Alamofire.request(.POST, API_URL + "/remindpassword", parameters: [
            "username": username!,
            "email":email!
            ],
            encoding:.JSON)
            .responseJSON { response in
                if(response.response?.statusCode == 200) {
                    showGlobalNotification("Reset link sent!", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandGreen())
                } else {
                    showGlobalNotification("Error sending reset link", duration: 3.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandRed())
                }
            
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        //let json = JSON(value)
                        self.dismissKeyboard()
                        Answers.logCustomEventWithName("Reset Password Success",
                            customAttributes: [:])
                        
                    }
                case .Failure(let error):
                    print(error)
                    showAlert(.Error, title: "Error", msg: "Failed to remind password, please check username/email is correct")

                    Answers.logCustomEventWithName("3D Touch to Dashboard",
                        customAttributes: [
                            "error": error.localizedDescription
                        ])
                }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
