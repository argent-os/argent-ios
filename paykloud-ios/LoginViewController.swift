//
//  LoginViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

var userData:JSON? // init user data, declare globally

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss loader
        SVProgressHUD.dismiss()
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
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
    
    override func viewDidAppear(animated: Bool) {
        self.emailTextField.keyboardType = UIKeyboardType.EmailAddress
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let email = emailTextField.text;
        let password = passwordTextField.text;
        
        // check for empty fields
        if(email!.isEmpty) {
            // display alert message
            displayAlertMessage("Email not entered");
            return;
        } else if(password!.isEmpty) {
            displayAlertMessage("Password not entered");
            return;
        }
        
        Alamofire.request(.POST, apiUrl + "/v1/login", parameters: [
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .responseJSON { response in
                //print(response.request) // original URL request
                //print(response.response?.statusCode) // URL response
                //print(response.data) // server data
                //print(response.result) // result of response serialization
                
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
                        
                        print("login was pressed")
                        
                        // Get the firebase token from server response
                        let AUTH_TOKEN = json["auth"]["token"].stringValue
                        
                        // Auth to firebase
                        firebaseUrl.authWithCustomToken(AUTH_TOKEN, withCompletionBlock: { error, authData in
                            if error != nil {
                                print("Login failed! \(error)")
                            } else {
                                print("Login succeeded! \(authData)")
                            }
                        })

                    }
                case .Failure(let error):
                    print(error)

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
        default:
            // Sent root view controller (default is login) otherwise send to register page
            let rootViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController"))! as UIViewController
            self.presentViewController(rootViewController, animated: true, completion: nil)
        }
    }
    
    func displayAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    


}
