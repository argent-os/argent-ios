
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
//import MXParallaxHeader

class HomeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var balanceLabel: UICountingLabel!
    
    //Changing Status Bar
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    // INIT TABLE
    var logs = [Log]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        cell.textLabel?.text = logs[indexPath.row].task
        // cell.detailTextLabel?.text = logs[indexPath.row].dateStart.toString()
        return cell
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
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "presentLeftMenuViewController")
        
        super.viewDidLoad()
        
        // Header
//        var headerView: UIImageView = UIImageView()
//        headerView.image = UIImage(named: "Background")
//        headerView.contentMode = .ScaleAspectFill
//        var scrollView: UIScrollView = UIScrollView()
//        scrollView.parallaxHeader.view = headerView
//        scrollView.parallaxHeader.height = 150
//        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
//        scrollView.parallaxHeader.minimumHeight = 20

//        scanCard({sender})

        // Load CardIO
        CardIOUtilities.preload()
        
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
    
    func mainSegmentControl(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            print("0 selected")
            // action for the first button (Current or Default)
        }
        else if segment.selectedSegmentIndex == 1 {
            print("1 selected")
            // action for the second button
        }
    }
    
    // STRIPE PAYMENT AUTH FINISHED
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // STAR BUTTON
    @IBAction func favorite(sender: StarButton!) {
        sender.isFavorite = !sender.isFavorite
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
            
            // Get stripe balance on appear
            // Set account balance label
            getStripeBalance() { responseObject, error in
                // use responseObject and error here
                // print("responseObject = \(responseObject); error = \(error)")
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                formatter.locale = NSLocale.currentLocale() // This is the default
                if responseObject?["pending"][0]["amount"].stringValue != nil {
                    let amt = responseObject?["pending"][0]["amount"].stringValue
                    print(amt)
                    if(amt == nil || amt == "") {
                        return
                    } else {
                        self.balanceLabel.countFrom(0, to: CGFloat(Float(amt!)!)/100)
                        self.balanceLabel.format = "%.2f"
                        self.balanceLabel.animationDuration = 3.0
                        self.balanceLabel.countFromZeroTo(CGFloat(Float(amt!)!)/100)
                        self.balanceLabel.method = UILabelCountingMethod.EaseInOut
                        self.balanceLabel.completionBlock = {
                            let balanceNum = formatter.stringFromNumber(Float(amt!)!/100)
                            self.balanceLabel.text = balanceNum
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