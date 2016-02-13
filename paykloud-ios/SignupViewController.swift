//
//  SignupViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let username = usernameTextField.text;
        let email = emailTextField.text;
        let password = passwordTextField.text;
        let repeatPassword = repeatPasswordTextField.text;
        
        // check for empty fields
        if(username!.isEmpty || email!.isEmpty || password!.isEmpty || repeatPassword!.isEmpty) {
            // display alert message
            displayAlertMessage("All fields are required");
            return;
        }
        
        if(password != repeatPassword) {
            // display alert
            displayAlertMessage("Passwords do not match");
            return;
        }
        

        Alamofire.request(.POST, apiUrl + "/v1/register", parameters: [
            "username":username!,
            "email":email!,
            "password":password!
            ],
            encoding:.JSON)
            .responseJSON { response in
                //print(response.request) // original URL request
                //print(response.response?.statusCode) // URL response
                //print(response.data) // server data
                //print(response.result) // result of response serialization
                
                SVProgressHUD.show()
                if(response.response?.statusCode == 200) {
                    // Login is successful
                    NSUserDefaults.standardUserDefaults().setBool(true,forKey:"userLoggedIn");
                    NSUserDefaults.standardUserDefaults().synchronize();
                    
                    // go to main view
                    self.performSegueWithIdentifier("loginView", sender: self);
                    
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                         print("Response: \(json)")
                        // assign userData to self, access globally
                        print("register success")
                        SVProgressHUD.dismiss()
                    }
                case .Failure(let error):
                    print(error)
                    SVProgressHUD.dismiss()
                }
        }

        
        displaySuccessAlertMessage("Registration Successful!  You can now login.")
    }

    
    func displayAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    func displaySuccessAlertMessage(alertMessage:String) {
        let displayAlert = UIAlertController(title: "Success", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        displayAlert.addAction(okAction);
        self.presentViewController(displayAlert, animated: true, completion: nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
