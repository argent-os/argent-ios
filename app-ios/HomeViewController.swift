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
import JGProgressHUD
import SwiftyJSON
import Stripe
import UICountingLabel
import DGRunkeeperSwitch
import BEMSimpleLineGraph
//import MXParallaxHeader

let userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")

class HomeViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    var itemsArray:Array<History>?
    var tableView:UITableView = UITableView()
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var arrayOfValues: Array<AnyObject> = [3,30,50,40,80]
    var user = User(username: "", email: "", first_name: "", last_name: "", cust_id: "", picture: "")
    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Balance", rightTitle: "Customers")

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var switchBal: DGRunkeeperSwitch?
    @IBOutlet weak var navigationBar: UINavigationItem!
    //@IBOutlet weak var balanceLabel: UICountingLabel!
    
    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
        if(sender.selectedIndex == 0) {
//            pendingBalanceView.hidden = false
//            availableBalanceView.hidden = true
        }
        if(sender.selectedIndex == 1) {
//            pendingBalanceView.hidden = true
//            availableBalanceView.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        
        let img: UIImage = UIImage(named: "Proton")!
        let protonImageView: UIImageView = UIImageView(frame: CGRectMake(20, 31, 40, 40))
        protonImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
//        protonImageView.center = CGPointMake(self.view.bounds.size.width / 2, 65)
        protonImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        protonImageView.layer.cornerRadius = protonImageView.frame.size.height/2
        protonImageView.layer.masksToBounds = true
        protonImageView.clipsToBounds = true
        protonImageView.image = img
        protonImageView.layer.borderWidth = 2
        protonImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
        self.view.addSubview(protonImageView)
        
        // Blurview
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = CGRectMake(0, 0, width, height)
        let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
        blurImageView.contentMode = .ScaleAspectFill
        blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        blurImageView.layer.masksToBounds = true
        blurImageView.clipsToBounds = true
        blurImageView.image = UIImage(named: "BackgroundGradientInverse")
        self.view.addSubview(blurImageView)
//        blurImageView.addSubview(visualEffectView)
        self.view.sendSubviewToBack(blurImageView)
        
        // Get the user profile with completion handler
        loadUserProfile{ (user, error) in
            print("got user in completion handler")
            print(user)
            let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user?.picture)!)!)!)!
            print(img)
            if img != "" {
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(20, 31, 40, 40))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
//                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 65)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 2
                userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
                self.view.addSubview(userImageView)
                self.view.bringSubviewToFront(userImageView)
            }
            
            // Customizable background view later in future
            // // Blurview
            // let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            // visualEffectView.frame = CGRectMake(0, 0, width, height)
            // let blurImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, width, height))
            // blurImageView.contentMode = .ScaleAspectFill
            // blurImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
            // blurImageView.layer.masksToBounds = true
            // blurImageView.clipsToBounds = true
            // blurImageView.image = img
            // self.view.addSubview(blurImageView)
            // blurImageView.addSubview(visualEffectView)
            // self.view.sendSubviewToBack(blurImageView)
        }
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let frame = CGRectMake(0, 100, screenWidth, 260)
        let graph: BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: frame)
        graph.dataSource = self
        graph.colorTop = UIColor.clearColor()
        graph.colorBottom = UIColor.protonDarkBlue()
        graph.colorLine = UIColor(rgba: "#0003")
        graph.colorPoint = UIColor.whiteColor()
        graph.colorBackgroundPopUplabel = UIColor.whiteColor()
        graph.delegate = self
        graph.widthLine = 3
        graph.displayDotsWhileAnimating = true
        graph.enablePopUpReport = true
        graph.enableTouchReport = true
        graph.enableBezierCurve = true
        graph.colorTouchInputLine = UIColor.whiteColor()
        graph.layer.masksToBounds = true
        self.view!.addSubview(graph)
        
        let mainSegment: UISegmentedControl = UISegmentedControl(items: ["1M", "3M", "6M", "1Y", "5Y"])
        mainSegment.frame = CGRect(x: 15.0, y: 300.0, width: view.bounds.width - 30.0, height: 30.0)
//        var y_co: CGFloat = self.view.frame.size.height - 100.0
//        mainSegment.frame = CGRectMake(10, y_co, width-20, 50.0)
        mainSegment.selectedSegmentIndex = 2
        mainSegment.removeBorders()
        mainSegment.addTarget(self, action: #selector(HomeViewController.mainSegmentControl(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(mainSegment)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: screenWidth, height: 50))
        navBar.barTintColor = UIColor.clearColor()
        navBar.translucent = true
        navBar.tintColor = UIColor.whiteColor()
        navBar.backgroundColor = UIColor.clearColor()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 18)!
        ]
        self.view.addSubview(navBar)
        self.view.sendSubviewToBack(navBar)
        let navItem = UINavigationItem(title: "")
        navBar.setItems([navItem], animated: true)
        
        runkeeperSwitch.backgroundColor = UIColor.clearColor()
        runkeeperSwitch.selectedBackgroundColor = UIColor.whiteColor()
        runkeeperSwitch.titleColor = UIColor.whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor.protonBlue()
        runkeeperSwitch.titleFont = UIFont(name: "Nunito-SemiBold", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: view.bounds.width - 205.0, y: 15, width: 200, height: 30.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        runkeeperSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        runkeeperSwitch.bringSubviewToFront(runkeeperSwitch)
        runkeeperSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        
        tableView.frame = CGRect(x: 0, y: 340, width: width, height: height-100)
        self.view.addSubview(tableView)

        let lblAccount:UILabel = UILabel()
        lblAccount.tintColor = UIColor.whiteColor()
        lblAccount.frame = CGRectMake(20, 81, 200, 40)
        let str = NSAttributedString(string: "$10,125", attributes:
            [
                NSFontAttributeName: UIFont(name: "Nunito-Regular", size: 18)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fff")
            ])
        lblAccount.attributedText = str
        self.view.addSubview(lblAccount)
        
        let lblDescription:UILabel = UILabel()
        lblDescription.frame = CGRectMake(20, 106, 200, 40)
        let str2 = NSAttributedString(string: "Available Balance", attributes:
            [
                NSFontAttributeName: UIFont(name: "Nunito-Regular", size: 12)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fffa")
            ])
        lblDescription.attributedText = str2
        self.view.addSubview(lblDescription)
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "presentLeftMenuViewController")
        
        super.viewDidLoad()
        
        // Transparent navigation bar
        // self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#1a8ef5")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor(rgba: "#157efb"),
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 18.0)!
        ]

    }
    
    override func viewDidDisappear(animated: Bool) {
        runkeeperSwitch.removeFromSuperview()
    }
    
    
    
    func mainSegmentControl(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            // action for the first button (Current or Default)
        }
        else if segment.selectedSegmentIndex == 1 {
            // action for the second button
        }
        else if segment.selectedSegmentIndex == 2 {
            // action for the third button
        }
        else if segment.selectedSegmentIndex == 3 {
            // action for the fourth button
        }
        
    }
    
    func loadUserProfile(completionHandler: (User?, NSError?) -> ()) {
        User.getProfile({ (item, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            print("got user")
            print(item)
            self.user = item!
            completionHandler(item!, error)
        })
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController!.navigationBar.addSubview(runkeeperSwitch)
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        UITextField.appearance().keyboardAppearance = .Light
        UIStatusBarStyle.LightContent

        // Check for user logged in key
        let userLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn");
        if(!userLoggedIn) {
            // check if user logged in, if not send to login
            print("user not logged in")
            // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
            let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        } else {

            if userData != nil {
                print("user data exists")
            }
            
//            let balanceVC = self.childViewControllers[0] as! BalanceViewController
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
                    NSNotificationCenter.defaultCenter().postNotificationName("balance", object: nil, userInfo: ["available_bal":availableAmt!,"pending_bal":pendingAmt!])

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
                        
//                        balanceVC.pendingBalanceLabel.countFrom((CGFloat(Float(pendingAmt!)!)/100)-100, to: CGFloat(Float(pendingAmt!)!)/100)
//                        balanceVC.pendingBalanceLabel.format = "%.2f"
//                        balanceVC.pendingBalanceLabel.animationDuration = 3.0
//                        balanceVC.pendingBalanceLabel.countFromZeroTo(CGFloat(Float(pendingAmt!)!)/100)
//                        balanceVC.pendingBalanceLabel.method = UILabelCountingMethod.EaseInOut
//                        balanceVC.pendingBalanceLabel.completionBlock = {
//                            let availableBalanceNum = formatter.stringFromNumber(Float(pendingAmt!)!/100)
//                            balanceVC.pendingBalanceLabel.text = availableBalanceNum
//                        }
                    }
                }
                return
            }
            
            print("user logged in, displaying home view")
            // Check user local data in json format, prevent re-retrieviing data from the server

        }
    }

    func getStripeBalance(completionHandler: (JSON?, NSError?) -> ()) {
        makeStripeCall("/v1/balance", completionHandler: completionHandler)
    }
    
    func makeStripeCall(endpoint: String, completionHandler: (JSON?, NSError?) -> ()) {

        // TODO: Make secret key call from API, find user by ID
        if let stripeKey = userData?["user"]["stripe"]["secretKey"].stringValue {
            let headers = [
                "Authorization": "Bearer " + (stripeKey),
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
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.textLabel.text = "Logging out"
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.3)
        
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

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.textLabel.text = "Logging out"
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.3)
        
        // go to login view
        self.performSegueWithIdentifier("loginView", sender: self);
        
    }
    
    // BEM Graph Delegate Methods
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return Int(self.arrayOfValues.count)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(self.arrayOfValues[index] as! NSNumber)
    }
    
    func overrideRAMTabBar() {
        // createConstraints(icon, container: container, size: itemImage.size, yOffset: -5)
        // if let itemImage = item.image {
        //    if 2 == index { // selected first elemet
        //        var size = CGSize(width: 40, height: 40)
        //        createConstraints(icon, container: container, size: size, yOffset: 0)
        //    } else {
        //        createConstraints(icon, container: container, size: itemImage.size, yOffset: -5)
        //
        //    }
        // }
    }
    
    // TableView Delegate
    
    func refresh(sender:AnyObject)
    {
//        self.loadAccountHistory()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = self.itemsArray?[indexPath.row]
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = "$1,129.32"
        if let text = item?.amount
        {
            cell.textLabel?.text = "Amount $" + text
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
}

extension UISegmentedControl {
    func removeBorders() {
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Nunito-Regular", size: 12)!],
            forState: .Normal)
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 18)!],
            forState: .Selected)
        setBackgroundImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColor(UIColor.clearColor(), source: "IconEmpty"), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor, source: String) -> UIImage {
        let rect = CGRectMake(10.0, 0.0, 100.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIImage(named: source)
        UIGraphicsEndImageContext();
        return image!
    }
}
