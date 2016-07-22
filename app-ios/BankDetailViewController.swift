//
//  DetailViewController.swift
//  Example
//
//  Created by Mathias Carignani on 5/19/15.
//  Copyright (c) 2015 Mathias Carignani. All rights reserved.
//

import UIKit
import TextFieldEffects
import Alamofire
import SwiftyJSON

class BankDetailViewController: UIViewController, UITextFieldDelegate {
    
    var color: UIColor?
    var logo: String?
    var bankName: String?
    var longBankName: String?
    var bankLogoImage: UIImage? = nil
    let idTextField = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField  = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))

//    func getInstitution(bankString: String) -> Institution {
//        var institution: Institution {
//            switch bankString {
//            case "amex":
//                return Institution.amex
//            case "bofa":
//                return .bofa
//            case "capone360":
//                return .capone360
//            case "chase":
//                return .chase
//            case "citi":
//                return .citi
//            case "fidelity":
//                return .fidelity
//            case "ncfu":
//                return .navy
//            case "pnc":
//                return .pnc
//            case "schwab":
//                return .schwab
//            case "suntrust":
//                return .suntrust
//            case "td":
//                return .tdbank
//            case "us":
//                return .us
//            case "usaa":
//                return .usaa
//            case "wells":
//                return .wells
//            default:
//                return .none
//            }
//        }
//        // Return institution enum
//        return institution
//    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.becomeFirstResponder()
        
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Dark keyboard for view
        UITextField.appearance().keyboardAppearance = .Dark
        
        view.backgroundColor = color
        
//        addToolbarButton()

        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        setNeedsStatusBarAppearanceUpdate()
        UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.tintColor = UIColor.lightGrayColor()
        
        let bankLogo = logo
        let bankImage = UIImage(named: bankLogo!)
        let bankLogoImageView = UIImageView(image: bankImage!)
        
        bankLogoImageView.frame = CGRectMake(screenWidth/2-35, 0, 70, 70)
        bankLogoImageView.contentMode = .ScaleAspectFit
        bankLogoImageView.frame.origin.y = screenHeight*0.08 // 10 down from the top

        view.addSubview(bankLogoImageView)
        
        // Programatically set the input fields
        idTextField.tag = 4443
        idTextField.textAlignment = NSTextAlignment.Center
        idTextField.borderActiveColor = UIColor(rgba: "#FFF4")
        idTextField.borderInactiveColor = UIColor(rgba: "#FFF9") // color with alpha
        idTextField.backgroundColor = UIColor.clearColor()
        idTextField.placeholder = longBankName! + " Username"
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
        
        passwordTextField.tag = 4444
        passwordTextField.textAlignment = NSTextAlignment.Center
        passwordTextField.borderActiveColor = UIColor(rgba: "#FFF4")
        passwordTextField.borderInactiveColor = UIColor(rgba: "#FFF9") // color with alpha
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderColor = UIColor.whiteColor()
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.Words
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.keyboardType = UIKeyboardType.Default
        passwordTextField.secureTextEntry = true
        passwordTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        passwordTextField.frame.origin.y = screenHeight*0.35 // 25 down from the top
        passwordTextField.frame.origin.x = (self.view.bounds.size.width - passwordTextField.frame.size.width) / 2.0
        passwordTextField.returnKeyType = UIReturnKeyType.Go
        view.addSubview(passwordTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "bankListView") {
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Connect", style: UIBarButtonItemStyle.Done, target: self, action: #selector(BankDetailViewController.login(_:)))
        done.tintColor = UIColor.whiteColor()
        UIToolbar.appearance().barTintColor = UIColor.whiteColor()
        done.setTitleTextAttributes([
            NSFontAttributeName : UIFont(name: "Avenir-Book", size: 15.0)!,
            NSForegroundColorAttributeName : color!
            ], forState: .Normal)

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
 
//        let institution = getInstitution(bankName!)
        if idTextField.text != "" || passwordTextField.text != "" {
//            PS_addUser(.Connect, username: idTextField.text!, password: passwordTextField.text!, pin: "", institution: institution, completion: { (response, accessToken, mfaType, mfa, accounts, transactions, error) in
//                    self.updateUserToken(accessToken)
//                    // post the accesstoken to the user api
//                    // print(accessToken)
//                    // print(mfaType)
//                    // print(mfa)
//                    // print(response!)
//                    // print(transactions!)
//                    // print(accounts)
//                    print("error is", error)
//                    if(error != nil) {
//                        print(error)
//                        HUD.textLabel.text = "Could not connect to bank"
//                        HUD.dismissAfterDelay(2)
//                    }
//            })
        }
    }
    
    func updateUserToken(token: String) {
        if userAccessToken != nil {
            
            let plaidObj = [ "access_token" : token ]
            let plaidNSDict = plaidObj as NSDictionary //no error message
 
            let parameters : [String : AnyObject] = [
                "plaid" : plaidNSDict
            ]
            
            let headers = [
                "Authorization": "Bearer " + (userAccessToken as! String),
                "Content-Type": "application/json"
            ]

            let endpoint = API_URL + "/profile"
            
            // Encoding as .JSON with header application/json
            Alamofire.request(.PUT, endpoint, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("success")
                    if let value = response.result.value {
                        _ = JSON(value)
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
//            login(self)
            return true
        }
        return false
    }
    
}