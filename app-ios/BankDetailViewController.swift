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
import Alamofire
import SwiftyJSON
import JGProgressHUD

class DetailViewController: UIViewController {
    
    var color: UIColor?
    var logo: String?
    var bankName: String?
    var bankLogoImage: UIImage? = nil
    let idTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))

    func getInstitution(bankString: String) -> Institution {
        var institution: Institution {
            switch bankString {
            case "amex":
                return Institution.amex
            case "bofa":
                return .bofa
            case "capone360":
                return .capone360
            case "chase":
                return .chase
            case "citi":
                return .citi
            case "fidelity":
                return .fidelity
            case "ncfu":
                return .navy
            case "pnc":
                return .pnc
            case "schwab":
                return .schwab
            case "suntrust":
                return .suntrust
            case "td":
                return .tdbank
            case "us":
                return .us
            case "usaa":
                return .usaa
            case "wells":
                return .wells
            default:
                return .none
            }
        }
        // Return institution enum
        return institution
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.becomeFirstResponder()
    
        // Dark keyboard for view
        UITextField.appearance().keyboardAppearance = .Dark
        
        print("color is", color)
        view.backgroundColor = color
        
        addToolbarButton()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        print("bank is ", bankName)
        
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
        idTextField.placeholder = "Bank Account Username"
        idTextField.placeholderColor = UIColor.whiteColor()
        idTextField.textColor = UIColor.whiteColor()
        idTextField.autocapitalizationType = UITextAutocapitalizationType.None
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
 
        let institution = getInstitution(bankName!)
        print(institution)
        if idTextField.text != "" || passwordTextField.text != "" {
            let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
            HUD.showInView(self.view!)
            HUD.textLabel.text = "Authenticating to " + bankName!
            HUD.dismissAfterDelay(1)
            PS_addUser(.Connect, username: idTextField.text!, password: passwordTextField.text!, pin: "", institution: institution, completion: { (response, accessToken, mfaType, mfa, accounts, transactions, error) in
                    print("success")
                    print(accessToken)
                    self.updateUserToken(accessToken)
                    // post the accesstoken to the user api
                    // print(mfaType)
                    // print(mfa)
                    // print(response!)
                    // print(transactions!)
                    print(accounts)
                    HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    HUD.textLabel.text = "Bank connected!"
                    HUD.dismissAfterDelay(2)
                    print("error is", error)
                    if(error != nil) {
                        print(error)
                        HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                        HUD.textLabel.text = "Could not connect to bank"
                        HUD.dismissAfterDelay(2)
                    }
            })
        }
    }
    
    func updateUserToken(token: String) {
        print("updating user token")
        if userAccessToken != nil {
            print("current auth token for proton", userAccessToken!)
            print("access token not null, setting headers")
            
            let plaidObj = [ "access_token" : token ]
            let plaidNSDict = plaidObj as NSDictionary //no error message
 
            let parameters : [String : AnyObject] = [
                "user" : (userData?.rawValue)!,
                "plaid" : plaidNSDict
            ]
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]

            let endpoint = apiUrl + "/v1/profile"
            
            print(endpoint)
            print(parameters)
            print(headers)
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        let data = JSON(value)
                        print("posted user data")
//                        print(data)
                    }
                case .Failure(let error):
                    print(error)
                }
            }
        }
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
    


}