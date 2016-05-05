//
//  LoginBoxTableViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/21/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD
import WatchConnectivity

class LoginBoxTableViewController: UITableViewController, WCSessionDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet var loginTableView: UITableView!
    @IBOutlet weak var usernameCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        let height = screen.size.height
        
        // Add button to keyboard
        addToolbarButton()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.tag = 63631
        let str = NSAttributedString(string: "Username or Email", attributes: [NSForegroundColorAttributeName:UIColor(rgba: "#fff")])
        usernameTextField.attributedPlaceholder = str
        usernameTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
        
        passwordTextField.tag = 63632
        let str2 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor(rgba: "#fff")])
        passwordTextField.attributedPlaceholder = str2
        passwordTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
        
        
        // Blurview
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = CGRectMake(0, 0, width, 330)
        let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, 330))
        blurImageView.contentMode = .ScaleAspectFill
        blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        blurImageView.layer.masksToBounds = true
        blurImageView.clipsToBounds = true
        blurImageView.image = UIImage(named: "BackgroundGradientInverse")
//        self.view.addSubview(blurImageView)
//        blurImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(blurImageView)
        
        loginTableView.separatorColor = UIColor(rgba: "#fff5")
        loginTableView.backgroundColor = UIColor(rgba: "#fff1")
        
        usernameCell.backgroundColor = UIColor.clearColor()
        usernameCell.textLabel?.textColor = UIColor.whiteColor()

        UITextField.appearance().tintColor = UIColor.blackColor()
        UITextView.appearance().tintColor = UIColor.blackColor()
        
        passwordCell.backgroundColor = UIColor.clearColor()
        passwordCell.textLabel?.textColor = UIColor.whiteColor()
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
        
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()

        done.setTitleTextAttributes([
                    NSFontAttributeName : UIFont(name: "Avenir-Light", size: 15.0)!,
                    NSForegroundColorAttributeName : UIColor.mediumBlue()
                    ], forState: .Normal)
        
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
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        // HUD.textLabel.text = "Logging in"
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.3)
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            displayErrorAlertMessage("Username or Email not entered");
            return;
        } else if(password!.isEmpty) {
            displayErrorAlertMessage("Password not entered");
            return;
        }
        
        Alamofire.request(.POST, apiUrl + "/v1/login", parameters: [
            "username": username!,
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                // print(totalBytesWritten)
                // print(totalBytesExpectedToWrite)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    // print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                // go to main view
                if(response.response?.statusCode == 200) {
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                } else {
                    self.displayDefaultErrorAlertMessage("Failed to login, please check username/email and password are correct");
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
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
                                            // TODO: Make secret key call from API, find user by ID
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

                        NSUserDefaults.standardUserDefaults().setValue(token, forKey: "userAccessToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        // go to main view
                        self.performSegueWithIdentifier("homeView", sender: self);
                        
                        self.dismissKeyboard()
                        
                    }
                case .Failure(let error):
                    print(error)
                    self.displayDefaultErrorAlertMessage("Failed to login, please check username/email and password are correct");
                }
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
//        UIToolbar.appearance().barTintColor = UIColor(rgba: "#1796fa")
//        UIToolbar.appearance().backgroundColor = UIColor(rgba: "#1796fa")
//        if let font = UIFont(name: "Avenir-Book", size: 15) {
//            UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
//            
//        }
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
            return true
        }
        return false
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayDefaultErrorAlertMessage(alertMessage:String) {
        let alertView: UIAlertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayAlertMessage(alertMessage:String) {
        let alertView: UIAlertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayErrorAlertMessage(alertMessage:String) {
        let alertView: UIAlertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}