
//
//  ViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import Stripe
import UICountingLabel
import DGRunkeeperSwitch
//import MXParallaxHeader

class HomeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var switchBal: DGRunkeeperSwitch?
    @IBOutlet weak var pendingBalanceView: UIView!
    @IBOutlet weak var availableBalanceView: UIView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    //@IBOutlet weak var balanceLabel: UICountingLabel!
    
    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
        if(sender.selectedIndex == 0) {
            pendingBalanceView.hidden = false
            availableBalanceView.hidden = true
        }
        if(sender.selectedIndex == 1) {
            pendingBalanceView.hidden = true
            availableBalanceView.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        // Programatically setup left navigation button
        // Create a navigation item with a title
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
        navBar.barTintColor = UIColor(rgba: "#FFF")
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.darkGrayColor(),
            NSFontAttributeName : UIFont(name: "Nunito", size: 20)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Balance");
        navBar.setItems([navItem], animated: false);
        
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Pending", rightTitle: "Available")
        runkeeperSwitch.backgroundColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.titleFont = UIFont(name: "Nunito-SemiBold", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 50.0, y: 80.0, width: view.bounds.width - 100.0, height: 30.0)
        runkeeperSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        runkeeperSwitch.autoresizingMask = [.FlexibleWidth]
        view.addSubview(runkeeperSwitch)
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "presentLeftMenuViewController")
        
        super.viewDidLoad()
        
        // Transparent navigation bar
        // self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#1a8ef5")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 18.0)!
        ]
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("chargeButtonTapped:")), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

    }
    
    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
        SVProgressHUD.dismiss()

        // Check for user logged in key
        let userLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn");
        if(!userLoggedIn) {
            // check if user logged in, if not send to login
            print("user not logged in")
            // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
            let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        } else {

            if userData != nil {
                print("user data exists")
            }
            
            let balanceVC = self.childViewControllers[0] as! BalanceViewController
            // Get stripe balance on appear
            // Set account balance label
            getStripeBalance() { responseObject, error in
                // use responseObject and error here
                // print("responseObject = \(responseObject); error = \(error)")
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                formatter.locale = NSLocale.currentLocale() // This is the default
                if responseObject?["pending"][0]["amount"].stringValue != nil {
                    let pendingAmt = responseObject?["pending"][0]["amount"].stringValue
                    let availableAmt = responseObject?["available"][0]["amount"].stringValue
                    if(pendingAmt == nil || pendingAmt == "" || availableAmt == nil || availableAmt == "") {
                        return
                    } else {
//                        balanceVC.availableBalanceLabel.countFrom(0, to: CGFloat(Float(pendingAmt!)!)/100)
//                        balanceVC.availableBalanceLabel.format = "%.2f"
//                        balanceVC.availableBalanceLabel.animationDuration = 3.0
//                        balanceVC.availableBalanceLabel.countFromZeroTo(CGFloat(Float(pendingAmt!)!)/100)
//                        balanceVC.availableBalanceLabel.method = UILabelCountingMethod.EaseInOut
//                        balanceVC.availableBalanceLabel.completionBlock = {
//                            let pendingBalanceNum = formatter.stringFromNumber(Float(pendingAmt!)!/100)
//                            balanceVC.availableBalanceLabel.text = pendingBalanceNum
//                        }
                        
                        balanceVC.pendingBalanceLabel.countFrom(0, to: CGFloat(Float(pendingAmt!)!)/100)
                        balanceVC.pendingBalanceLabel.format = "%.2f"
                        balanceVC.pendingBalanceLabel.animationDuration = 3.0
                        balanceVC.pendingBalanceLabel.countFromZeroTo(CGFloat(Float(pendingAmt!)!)/100)
                        balanceVC.pendingBalanceLabel.method = UILabelCountingMethod.EaseInOut
                        balanceVC.pendingBalanceLabel.completionBlock = {
                            let availableBalanceNum = formatter.stringFromNumber(Float(pendingAmt!)!/100)
                            balanceVC.pendingBalanceLabel.text = availableBalanceNum
                        }
                    }
                }
                return
            }
            
            print("user logged in, displaying home view")
            SVProgressHUD.dismiss()
            // Check user local data in json format, prevent re-retrieviing data from the server

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale() // This is the default
            let userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")
            print("user token is", userAccessToken)
            if userData == nil && userAccessToken != nil {
                let headers = [
                    "Authorization": "Bearer " + (userAccessToken as! String),
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                Alamofire.request(.GET, apiUrl + "/v1/profile", headers: headers)
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            print("success")
                            if let value = response.result.value {
                                userData = JSON(value)
                                print("got user data")
                            }
                        case .Failure(let error):
                            self.logout()
                            print(error)
                        }
                    }
            }
        }
    }

    func getStripeBalance(completionHandler: (JSON?, NSError?) -> ()) {
        makeStripeCall("/v1/balance", completionHandler: completionHandler)
    }
    
    func makeStripeCall(endpoint: String, completionHandler: (JSON?, NSError?) -> ()) {

        if let stripeKey = userData?["user"]["stripe"]["secretKey"].stringValue {
            let headers = [
                "Authorization": "Bearer " + (stripeKey ),
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            Alamofire.request(.GET, stripeApiUrl + endpoint,
                encoding:.URL,
                headers: headers)
                .responseJSON { response in
                    print(response.request) // original URL request
                    print(response.response?.statusCode) // URL response
                    print(response.data) // server data
                    print(response.result) // result of response serialization
                    
                    // go to main view
                    if(response.response?.statusCode == 200) {
                        print("green light")
                    } else {
                        print("red light")
                    }
                    
                    switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            completionHandler(json, nil)
                        }
                    case .Failure(let error):
                        print(error)
                        completionHandler(nil, error)
                    }
            }
        }
    }
    
    // Charge View
    @IBAction func chargeButtonTapped(sender: AnyObject) {
        SVProgressHUD.show()
        // go to charge view
        self.performSegueWithIdentifier("chargeView", sender: self);
    }
    
    // LOGOUT
    func logout() {
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userAccessToken")
        NSUserDefaults.standardUserDefaults().synchronize();
        userData = nil
        print("logging out")
        print(userData)
//        print(NSUserDefaults.valueForKey("userLoggedIn"))
        SVProgressHUD.show()
        // go to login view
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController")
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        root!.presentViewController(loginVC, animated: false, completion: { () -> Void in
            print("success logout")
        })
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        userData = nil
        print("logging out")
        print(userData)
        print(NSUserDefaults.valueForKey("userLoggedIn"))
        SVProgressHUD.show()
        // go to login view
        self.performSegueWithIdentifier("loginView", sender: self);
        
    }
    
}