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
import WatchConnectivity
import Crashlytics
import OnePasswordExtension

class LoginBoxTableViewController: UITableViewController, UITextFieldDelegate, WCSessionDelegate {

    var window:UIWindow = UIWindow()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet var loginTableView: UITableView!
    
    @IBOutlet weak var usernameCell: UITableViewCell!
    
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    let toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        let screen = UIScreen.mainScreen().bounds
        let _ = screen.size.width
        
        loginTableView.tableFooterView = UIView()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        usernameTextField.tag = 63631
        let str = NSAttributedString(string: "Username or Email", attributes: [NSForegroundColorAttributeName:UIColor.lightBlue()])
        usernameTextField.attributedPlaceholder = str
        usernameTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
        usernameTextField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
        usernameTextField.tintColor = UIColor.pastelBlue()
        usernameTextField.addTarget(LoginViewController(), action: #selector(LoginViewController().textFieldDidChange(_:)), forControlEvents: .EditingChanged)

        passwordTextField.tag = 63632
        let str2 = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIColor.lightBlue()])
        passwordTextField.attributedPlaceholder = str2
        passwordTextField.textRectForBounds(CGRectMake(0, 0, 0, 0))
        passwordTextField.clearsOnBeginEditing = false
        passwordTextField.font = UIFont(name: "MyriadPro-Regular", size: 15)!
        passwordTextField.tintColor = UIColor.pastelBlue()
        passwordTextField.addTarget(LoginViewController(), action: #selector(LoginViewController().textFieldDidChange(_:)), forControlEvents: .EditingChanged)

        loginTableView.separatorColor = UIColor.paleBlue().colorWithAlphaComponent(0.5)
        loginTableView.backgroundColor = UIColor.whiteColor()
        
        usernameCell.backgroundColor = UIColor.clearColor()
        usernameCell.textLabel?.textColor = UIColor.lightBlue()
        
        passwordCell.backgroundColor = UIColor.clearColor()
        passwordCell.textLabel?.textColor = UIColor.lightBlue()
        
        // Blurview
        // let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        // visualEffectView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        // self.view.addSubview(visualEffectView)
        // self.view.sendSubviewToBack(visualEffectView)
    }
    
    // Add send toolbar
    func addToolbarButton() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        toolBar.frame = CGRect(x: 0, y: screenHeight-250, width: screenWidth, height: 50)
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = false
        toolBar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let next: UIBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.login(_:)))
        
        UIToolbar.appearance().barTintColor = UIColor.brandGreen()
        UIToolbar.appearance().backgroundColor = UIColor.brandGreen()

        next.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 15)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ], forState: .Normal)
        
        toolBar.setItems([flexSpace, next, flexSpace], animated: false)
        toolBar.userInteractionEnabled = true
        
        usernameTextField.inputAccessoryView=toolBar
        passwordTextField.inputAccessoryView=toolBar
    }
    
    func login(sender: AnyObject) {

        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        if(usernameTextField.text == "" || passwordTextField.text == "") {
            displayAlertMessage("Fields cannot be empty")
            activityIndicator.stopAnimating()
            activityIndicator.hidden = true
        }
        
        Auth.login(usernameTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!) { (token, grant, username, err) in
            if(grant == true && token != "") {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.performSegueWithIdentifier("homeView", sender: self)
                
                Answers.logLoginWithMethod("Default",
                                           success: true,
                                           customAttributes: [
                                                "user": username
                                            ])
                
                // Send access token and Stripe key to Apple Watch
                if WCSession.isSupported() { //makes sure it's not an iPad or iPod
                    let watchSession = WCSession.defaultSession()
                    watchSession.delegate = self
                    watchSession.activateSession()
                    if watchSession.paired && watchSession.watchAppInstalled {
                        do {
                            try watchSession.updateApplicationContext(
                                [
                                    "token": token
                                ]
                            )
                            print("setting watch data")
                        } catch let error as NSError {
                            print(error.description)
                        }
                    }
                }
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                Answers.logLoginWithMethod("Default",
                                           success: false,
                                           customAttributes: [
                                            "error": "Error using default login method"
                    ])
                self.displayAlertMessage("Error logging in")
            }
        }
    }
    
    func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
    
    func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 0, 10)
    }
    
    override func viewWillDisappear(animated: Bool) {

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
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController = (sb.instantiateViewControllerWithIdentifier("RootViewController")) as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
            self.window.rootViewController = rootViewController
            UIApplication.sharedApplication().keyWindow?.rootViewController = rootViewController
            // critical: ensures rootViewController is set on login
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
            self.login(self)
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
