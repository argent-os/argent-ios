//
//  LoginBoxTableViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/21/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SIAlertView
import WatchConnectivity

class LoginBoxTableViewController: UITableViewController, WCSessionDelegate {
    
    @IBOutlet weak var usernameCell: UITableViewCell!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add button to keyboard
        addToolbarButton()
        
        usernameTextField.becomeFirstResponder()

        usernameCell.layer.borderColor = UIColor.redColor().CGColor
        
        usernameTextField.tag = 4
        let str = NSAttributedString(string: "Username or Email", attributes: [NSForegroundColorAttributeName:UIColor(rgba: "#333a")])
        usernameTextField.attributedPlaceholder = str
        usernameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        usernameTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
        
        passwordTextField.tag = 5
        let str2 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(rgba: "#333a")])
        passwordTextField.attributedPlaceholder = str2
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
    }
    
    func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
    // text position
    
    func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
    
    // Add send toolbar
    func addToolbarButton()
    {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let sendToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, screenWidth, 50))
        // sendToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Done, target: self, action: #selector(LoginBoxTableViewController.loginButtonTapped(_:)))
        
        var items: [UIBarButtonItem]? = [UIBarButtonItem]()
        items?.append(flexSpace)
        items?.append(done)
        items?.append(flexSpace)
        
        sendToolbar.items = items
        sendToolbar.sizeToFit()
        passwordTextField.inputAccessoryView=sendToolbar
        usernameTextField.inputAccessoryView=sendToolbar
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let email = usernameTextField.text
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        SVProgressHUD.show()
        
        print("login button tapped")
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            displayAlertMessage("Username/Email not entered");
            //            SVProgressHUD.dismiss()
            return;
        } else if(password!.isEmpty) {
            displayAlertMessage("Password not entered");
            //            SVProgressHUD.dismiss()
            return;
        }
        
        Alamofire.request(.POST, apiUrl + "/v1/login", parameters: [
            "username": username!,
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                print(totalBytesExpectedToWrite)
                
                SVProgressHUD.showProgress(Float(totalBytesExpectedToWrite), status: "Logging in", maskType: SVProgressHUDMaskType.Black)

                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                // go to main view
                print("login pressed")
                if(response.response?.statusCode == 200) {
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("green light")
                } else {
                    print("red light")
                    self.displayErrorAlertMessage("Failed to login, please check username/email and password are correct");
                    //                    SVProgressHUD.dismiss()
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print("User Data: \(userData)")
                        // assign userData to self, access globally
                        userData = json
                        
                        // Send access token and Stripe key to Apple Watch
                        if WCSession.isSupported() { //makes sure it's not an iPad or iPod
                            let watchSession = WCSession.defaultSession()
                            watchSession.delegate = self
                            watchSession.activateSession()
                            if watchSession.paired && watchSession.watchAppInstalled {
                                do {
                                    try watchSession.updateApplicationContext(
                                        [
                                            "user_token": userData!["token"].stringValue,
                                            "stripe_key": userData!["user"]["stripe"]["secretKey"].stringValue,
                                            "account_id": userData!["user"]["stripe"]["accountId"].stringValue
                                        ]
                                    )
                                    print("setting watch data")
                                } catch let error as NSError {
                                    print(error.description)
                                }
                            }
                        }
                        
                        let token = userData!["token"].stringValue
                        print("token is", token)
                        // Login is successful
                        print("is user logged in", NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn"))
                        NSUserDefaults.standardUserDefaults().setValue(token, forKey: "userAccessToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        print("user token is", NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken"))
                        //                        SVProgressHUD.dismiss()
                        
                        // go to main view
                        self.performSegueWithIdentifier("homeView", sender: self);
                        
                        //print(json)
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    print(error)
                    self.displayErrorAlertMessage("Failed to login, please check username/email and password are correct");
                }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // IMPORTANT: This allows the rootViewController to be prepared upon login when preparing for segue (transition) to the HomeViewController
        // Without this the side nav menu will not work!
        switch sender?.tag {
        case 1?:
            // Login button pressed
            print("logging in")
        case 2?:
            // Signup button pressed
            print("signup pressed")
        case 3?:
            // New signup button pressed
            print("new signup pressed")
        default:
            // Sent root view controller (default is login) otherwise send to register page
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
            print("sending root view controller")
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
        } else {
            // Not found, so remove keyboard.
            self.loginButtonTapped(self)
            textField.resignFirstResponder()
            dismissKeyboard()
            return true
        }
        return false
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayAlertMessage(alertMessage:String) {
        var alertView: SIAlertView = SIAlertView(title: "Alert", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
//        alertView.addButtonWithTitle("Button2", type: SIAlertViewButtonType.Destructive, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let alertView: SIAlertView = SIAlertView(title: "Error", andMessage: alertMessage)
        alertView.addButtonWithTitle("Ok", type: SIAlertViewButtonType.Default, handler: nil)
        //        alertView.addButtonWithTitle("Button2", type: SIAlertViewButtonType.Destructive, handler: nil)
        alertView.transitionStyle = SIAlertViewTransitionStyle.DropDown
        alertView.show()
    }
}