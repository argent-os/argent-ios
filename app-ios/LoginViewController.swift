//
//  LoginViewController.swift
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
import TransitionTreasury
import TransitionAnimation

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var loginBox: UIView!
    
    let imageView = UIImageView()

    weak var modalDelegate: ModalViewControllerDelegate?

    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    override func viewDidAppear(animated: Bool) {
        userData = nil
        addSubviewWithBounce(imageView)
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        // Set background image
        let backgroundView: UIImageView = UIImageView(image: UIImage(named: "BackgroundBusiness1"))
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundView.frame = self.view.bounds
        self.view!.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userAccessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        UITextField.appearance().keyboardAppearance = .Dark
        
        // Add action to close button to return to auth view
        closeButton.addTarget(self, action: #selector(LoginViewController.goToAuth(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addTarget(self, action: #selector(LoginViewController.goToAuth(_:)), forControlEvents: UIControlEvents.TouchUpOutside)
        
        // Login box, set height of container to match embedded tableview
        let containerFrame: CGRect = self.loginBox.frame
        loginBox.frame = containerFrame
        loginBox.layer.cornerRadius = 5
        loginBox.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.3).CGColor
        loginBox.layer.borderWidth = 1
        loginBox.layer.masksToBounds = true
        
        // Border radius on uiview
        view.layer.cornerRadius = 0
        view.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let imageName = "Logo"
        let image = UIImage(named: "Logo")
        imageView.image = image
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.tag = 42312
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.frame.origin.y = screenHeight*0.10 // 10% down from the top
        imageView.frame.origin.x = (self.view.bounds.size.width - imageView.frame.size.width) / 2.0 // centered left to right.
    }
    
    func addSubviewWithBounce(view: UIView) {
        // view.transform = CGAffineTransformMakeTranslation(self.view.frame.origin.x,self.view.frame.origin.y - self.view.frame.size.height * 0.2)
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.view.addSubview(view)
        UIView.animateWithDuration(0.3 / 1.5, animations: {() -> Void in
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                            view.transform = CGAffineTransformIdentity
                        })
                })
        })
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
        viewController.modalTransitionStyle = .CrossDissolve
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


