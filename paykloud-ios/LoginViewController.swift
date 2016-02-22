//
//  LoginViewController.swift
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

var alreadyAdjusted:Bool = false
class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let emailTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    


    // Set up initial view height adjustment to false
    var adjustingHeightBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Focuses view controller on first name text input
        if(alreadyAdjusted==false) {
            emailTextField.becomeFirstResponder()
        } else if let userUsername = NSUserDefaults.standardUserDefaults().stringForKey("userUsername") {
            emailTextField.text = userUsername
            passwordTextField.becomeFirstResponder()
        }
        
        // Add close button to keyboards
        addCloseButtonKeyBoard()

        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        loginButton.backgroundColor = UIColor(rgba: "#1aa8f6")
            
        // Border radius on uiview
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        // Inherit UITextField Delegate, this is used for next and go on keyboard
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Tags are 4 and 5 due to signup view textfields taking values 0-3
        emailTextField.tag = 4
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.borderActiveColor = UIColor(rgba: "#FFF")
        emailTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.placeholder = "Username or Email"
        emailTextField.placeholderColor = UIColor.grayColor()
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.returnKeyType = UIReturnKeyType.Next
        emailTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        emailTextField.textColor = UIColor.grayColor()
        emailTextField.frame.origin.y = screenHeight*0.20 // 25 down from the top
        emailTextField.frame.origin.x = (self.view.bounds.size.width - emailTextField.frame.size.width) / 2.0
        emailTextField.returnKeyType = UIReturnKeyType.Next
        view.addSubview(emailTextField)
        
        passwordTextField.tag = 5
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.borderActiveColor = UIColor(rgba: "#FFF")
        passwordTextField.borderInactiveColor = UIColor(rgba: "#FFFA") // color with alpha
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderColor = UIColor.grayColor()
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.textColor = UIColor.grayColor()
        passwordTextField.returnKeyType = UIReturnKeyType.Next
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.secureTextEntry = true
        passwordTextField.frame.origin.y = screenHeight*0.30 // 25 down from the top
        passwordTextField.frame.origin.x = (self.view.bounds.size.width - passwordTextField.frame.size.width) / 2.0
        passwordTextField.returnKeyType = UIReturnKeyType.Go
        view.addSubview(passwordTextField)
        
        // Dismiss loader
        SVProgressHUD.dismiss()
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Set up auto align keyboard with ui button
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        let email = emailTextField.text
        let username = emailTextField.text
        let password = passwordTextField.text
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            displayAlertMessage("Username/Email not entered");
            return;
        } else if(password!.isEmpty) {
            displayAlertMessage("Password not entered");
            return;
        }
        
        Alamofire.request(.POST, apiUrl + "/v1/login", parameters: [
            "username": username!,
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .responseJSON { response in
                //print(response.request) // original URL request
                //print(response.response?.statusCode) // URL response
                //print(response.data) // server data
                //print(response.result) // result of response serialization
                
                //print("login pressed")
                if(response.response?.statusCode == 200) {
                    // Login is successful
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    
                    // go to main view
                    self.performSegueWithIdentifier("homeView", sender: self);
                    
                }

                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        // print("User Data: \(userData)")                        
                        // assign userData to self, access globally
                        userData = json
                        
                        //print(json)
                        self.dismissKeyboard()
                        
                        // Get the firebase token from server response
                        let AUTH_TOKEN = json["auth"]["token"].stringValue
                        
                        // Auth to firebase
                        firebaseUrl.authWithCustomToken(AUTH_TOKEN, withCompletionBlock: { error, authData in
                            if error != nil {
                                // print("Login failed! \(error)")
                                self.displayErrorAlertMessage("Failed to login, please check email and password are correct");

                            } else {
                                // print("Login succeeded! \(authData)")
                            }
                        })

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
            print("neither login or signup pressed")
        }
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
    
    // Add done toolbar
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
        passwordTextField.inputAccessoryView=closeToolbar
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
            self.loginButtonTapped(self)
            textField.resignFirstResponder()
            dismissKeyboard()
            return true
        }
        
        return false
        
    }
    
    // Adjusts keyboard height to view
    func adjustingHeight(show:Bool, notification:NSNotification) {
        if(alreadyAdjusted == false) {
            // Check if already adjusted height
            var userInfo = notification.userInfo!
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let changeInHeight = (CGRectGetHeight(keyboardFrame) - 5) * (show ? 1 : -1)
            UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                self.bottomConstraint.constant += changeInHeight
            })
            // Already adjusted height so make it true so it doesn't continue adjusting everytime a label is focused
            alreadyAdjusted = true
        }
    }

    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
