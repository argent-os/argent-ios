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
import TextFieldEffects
import UIColor_Hex_Swift

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var loginBox: UIView!
    
    let emailTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    let passwordTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
    
    // Set up initial view height adjustment to false
    var alreadyAdjusted:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        userData = nil
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
//        SVProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        SVProgressHUD.show()

        UITextField.appearance().keyboardAppearance = .Dark
        
        // Add action to close button to return to auth view
        closeButton.addTarget(self, action: "goToAuth:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Login box radius
        loginBox.layer.cornerRadius = 5
        loginBox.layer.borderColor = UIColor(rgba: "#0b265a").CGColor
        loginBox.layer.borderWidth = 1
        loginBox.layer.masksToBounds = true

        // Border radius on uiview
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        
        // Dismiss loader
//        SVProgressHUD.dismiss()
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Set the ID in the storyboard in order to enable transition!
    func goToAuth(sender:AnyObject!)
    {
        // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
        let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

class HTTPManager: Alamofire.Manager {
    static let sharedManager: HTTPManager = {
        //let configuration = Timberjack.defaultSessionConfiguration()
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "192.168.1.182:": .DisableEvaluation
        ]
        var policy: ServerTrustPolicy = ServerTrustPolicy.DisableEvaluation
        let manager = HTTPManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return manager
    }()
}


