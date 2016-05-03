//
//  ViewController.swift
//  argent-ios
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
import DGRunkeeperSwitch
import BEMSimpleLineGraph
import UICountingLabel
import DGElasticPullToRefresh
import Gecco

var userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")

class HomeViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, UITableViewDelegate, UITableViewDataSource  {

    var accountHistoryArray:Array<History>?
    
    var tableView:UITableView = UITableView()
    
    var arrayOfValues: Array<AnyObject> = [30,10,20,50,60,80]
    
    var user = User(id: "", username: "", email: "", first_name: "", last_name: "", cust_id: "", picture: "")
    
    let lblAccountPending:UICountingLabel = UICountingLabel()

    let lblAccountAvailable:UICountingLabel = UICountingLabel()

    let lblAvailableDescription:UILabel = UILabel()

    let lblPendingDescription:UILabel = UILabel()

    let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Pending", rightTitle: "Available")

    let graph: BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.size.width, 190))

    @IBOutlet weak var blurView: UIVisualEffectView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var switchBal: DGRunkeeperSwitch?
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBAction func indexChanged(sender: DGRunkeeperSwitch) {
        if(sender.selectedIndex == 0) {
            lblAccountAvailable.removeFromSuperview()
            lblAvailableDescription.removeFromSuperview()
            
            self.view.addSubview(lblAccountPending)
            self.view.addSubview(lblPendingDescription)
        }
        if(sender.selectedIndex == 1) {
            lblAccountPending.removeFromSuperview()
            lblPendingDescription.removeFromSuperview()
            
            self.view.addSubview(lblAccountAvailable)
            self.view.addSubview(lblAvailableDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth()
        
        configureView()
        
    }
    
    func presentTutorial(sender: AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TutorialHomeViewController") as! TutorialHomeViewController
        viewController.alpha = 0.5
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        runkeeperSwitch.removeFromSuperview()
    }
    
    func mainSegmentControl(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            // action for the first button (Current or Default)
            arrayOfValues = [30,20,30,80]
            graph.reloadGraph()
        }
        else if segment.selectedSegmentIndex == 1 {
            // action for the second button
            arrayOfValues = [20,60,30]
            graph.reloadGraph()
        }
        else if segment.selectedSegmentIndex == 2 {
            // action for the third button
            arrayOfValues = [30,10,20,50,60,80]
            graph.reloadGraph()
        }
        else if segment.selectedSegmentIndex == 3 {
            // action for the fourth button
            arrayOfValues = [10,90,60,50,30,10,90,60,50,30,20,40]
            graph.reloadGraph()
        }
        else if segment.selectedSegmentIndex == 4 {
            // action for the fourth button
            arrayOfValues = [10,90,60,50,30]
            graph.reloadGraph()
        }
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

    }
    
    func auth() {
        
        // IMPORTANT: load new access token on home load, otherwise the old token will be requested to the server
        userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.showInView(graph)
        
        // Check for user logged in key
        print("user access token")
        print(userAccessToken)
        
        if((userAccessToken) != nil) {
            print("token retrieved! ", userAccessToken)
            
            // Get stripe data
            loadStripe()
            
            // Get user account history
            loadAccountHistory { (historyArr, error) in
                print("loading account history")
                if error != nil {
                    print(error)
                }
                print(historyArr)
                HUD.dismiss()
            }
            
            // Get user profile
            loadUserProfile { (user, error) in
                print("got user in completion handler")
                print(user)
                // let img = UIImage(named: "Proton")
                if user?.picture != nil && user?.picture != "" {
                    let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user?.picture)!)!)!)!
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
                } else {
                    
                }
            }
        } else {
            // check if user logged in, if not send to login
            print("user not logged in")
            // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
            let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }

    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let width = screen.size.width
        let height = screen.size.height
        
        let img: UIImage = UIImage(named: "Proton")!
        let logoImageView: UIImageView = UIImageView(frame: CGRectMake(20, 31, 40, 40))
        logoImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        logoImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        logoImageView.layer.cornerRadius = logoImageView.frame.size.height/2
        logoImageView.layer.masksToBounds = true
        logoImageView.clipsToBounds = true
        logoImageView.image = img
        logoImageView.layer.borderWidth = 2
        logoImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
        self.view.addSubview(logoImageView)
        
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
        
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        graph.dataSource = self
        graph.colorTop = UIColor.clearColor()
        graph.colorBottom = UIColor.darkBlue()
        graph.colorLine = UIColor(rgba: "#0003")
        graph.colorPoint = UIColor.whiteColor()
        graph.colorBackgroundPopUplabel = UIColor.whiteColor()
        graph.delegate = self
        graph.widthLine = 3
        graph.displayDotsWhileAnimating = true
        graph.enablePopUpReport = true
        graph.noDataLabelColor = UIColor.whiteColor()
        graph.enableTouchReport = true
        graph.enableBezierCurve = true
        graph.colorTouchInputLine = UIColor.whiteColor()
        graph.layer.masksToBounds = true
        self.view!.addSubview(graph)
        
        let mainSegment: UISegmentedControl = UISegmentedControl(items: ["1M", "3M", "6M", "1Y", "5Y"])
        mainSegment.frame = CGRect(x: 15.0, y: 230.0, width: view.bounds.width - 30.0, height: 30.0)
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
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18)!
        ]
        self.view.addSubview(navBar)
        self.view.sendSubviewToBack(navBar)
        let navItem = UINavigationItem(title: "")
        navBar.setItems([navItem], animated: true)
        
        runkeeperSwitch.backgroundColor = UIColor.clearColor()
        runkeeperSwitch.selectedBackgroundColor = UIColor.whiteColor()
        runkeeperSwitch.titleColor = UIColor.whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor.mediumBlue()
        runkeeperSwitch.titleFont = UIFont(name: "Avenir-Book", size: 12.0)
        runkeeperSwitch.frame = CGRect(x: view.bounds.width - 205.0, y: 15, width: 200, height: 30.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        runkeeperSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        runkeeperSwitch.bringSubviewToFront(runkeeperSwitch)
        runkeeperSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60))
        headerView.backgroundColor = UIColor.clearColor()

        let headerViewTitle: UILabel = UILabel()
        headerViewTitle.frame = CGRect(x: 0, y: 15, width: screenWidth, height: 40)
        headerViewTitle.text = "Account Activity"
        headerViewTitle.font = UIFont(name: "Avenir-Book", size: 16)
        headerViewTitle.textAlignment = .Center
        headerViewTitle.textColor = UIColor.darkGrayColor()
        headerView.addSubview(headerViewTitle)
        
        let tutorialButton:UIButton = UIButton()
        tutorialButton.frame = CGRect(x: width-40, y: 22, width: 22, height: 22)
        tutorialButton.setImage(UIImage(named: "ic_question"), forState: .Normal)
        tutorialButton.setTitle("Tuts", forState: .Normal)
        tutorialButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        tutorialButton.addTarget(self, action: #selector(HomeViewController.presentTutorial(_:)), forControlEvents: .TouchUpInside)
        tutorialButton.addTarget(self, action: #selector(HomeViewController.presentTutorial(_:)), forControlEvents: .TouchUpOutside)
        headerView.addSubview(tutorialButton)
        headerView.bringSubviewToFront(tutorialButton)
        
        tableView.frame = CGRect(x: 0, y: 270, width: width, height: height-315)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        
        lblAccountAvailable.tintColor = UIColor.whiteColor()
        lblAccountAvailable.frame = CGRectMake(20, 81, 200, 40)
        let str0 = NSAttributedString(string: "$0.00", attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Book", size: 18)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fff")
            ])
        lblAccountAvailable.attributedText = str0
        
        lblAccountPending.tintColor = UIColor.whiteColor()
        lblAccountPending.frame = CGRectMake(20, 81, 200, 40)
        let str1 = NSAttributedString(string: "$0.00", attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Book", size: 18)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fff")
            ])
        lblAccountPending.attributedText = str1
        self.view.addSubview(lblAccountPending)
        
        lblAvailableDescription.frame = CGRectMake(20, 106, 200, 40)
        let str2 = NSAttributedString(string: "Available Balance", attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Book", size: 12)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fffa")
            ])
        lblAvailableDescription.attributedText = str2
        // add available label initially
        
        lblPendingDescription.frame = CGRectMake(20, 106, 200, 40)
        let str3 = NSAttributedString(string: "Pending Balance", attributes:
            [
                NSFontAttributeName: UIFont(name: "Avenir-Book", size: 12)!,
                NSForegroundColorAttributeName:UIColor(rgba: "#fffa")
            ])
        lblPendingDescription.attributedText = str3
        self.view.addSubview(lblPendingDescription)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
                self?.loadAccountHistory({ (_: [History]?, NSError) in
                    print("reloaded")
                })
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(graph.colorBottom)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        // Transparent navigation bar
        // self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#1a8ef5")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.mediumBlue(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18.0)!
        ]

    }
    
    func loadAccountHistory(completionHandler: ([History]?, NSError?) -> ()) {
        print("load account history called")
        History.getAccountHistory({ (items, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load history \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            print("got history")
            print(items)
            self.accountHistoryArray = items
            completionHandler(items!, error)
            self.tableView.reloadData()
        })
    }
    
    func loadStripe() {
        // Set account balance label
        getStripeBalance() { responseObject, error in
            // use responseObject and error here
            // print("responseObject = \(responseObject); error = \(error)")
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale() // This is the default
            if responseObject?["balance"]["pending"][0]["amount"].stringValue != nil {
                let pendingAmt = responseObject?["balance"]["pending"][0]["amount"].stringValue
                let availableAmt = responseObject?["balance"]["available"][0]["amount"].stringValue
                print(responseObject)
                print("available amount is")
                print(availableAmt)
                NSNotificationCenter.defaultCenter().postNotificationName("balance", object: nil, userInfo: ["available_bal":availableAmt!,"pending_bal":pendingAmt!])
                
                if(pendingAmt == nil || pendingAmt == "" || availableAmt == nil || availableAmt == "") {
                    return
                } else {
                    self.lblAccountPending.countFrom(0, to: CGFloat(Float(pendingAmt!)!)/100)
                    self.lblAccountPending.textColor = UIColor.whiteColor()
                    self.lblAccountPending.format = "%.2f"
                    self.lblAccountPending.animationDuration = 2.0
                    self.lblAccountPending.countFromZeroTo(CGFloat(Float(pendingAmt!)!)/100)
                    self.lblAccountPending.method = UILabelCountingMethod.EaseInOut
                    self.lblAccountPending.completionBlock = {
                        let pendingBalanceNum = formatter.stringFromNumber(Float(pendingAmt!)!/100)
                        self.lblAccountPending.text = pendingBalanceNum!
                    }
                    
                    self.lblAccountAvailable.countFrom((CGFloat(Float(availableAmt!)!)/100)-100, to: CGFloat(Float(availableAmt!)!)/100)
                    self.lblAccountAvailable.textColor = UIColor.whiteColor()
                    self.lblAccountAvailable.format = "%.2f"
                    self.lblAccountAvailable.animationDuration = 2.0
                    self.lblAccountAvailable.countFromZeroTo(CGFloat(Float(availableAmt!)!)/100)
                    self.lblAccountAvailable.method = UILabelCountingMethod.EaseInOut
                    self.lblAccountAvailable.completionBlock = {
                        let availableBalanceNum = formatter.stringFromNumber(Float(availableAmt!)!/100)
                        self.lblAccountAvailable.text = availableBalanceNum!
                    }
                }
            }
            return
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
    
    func getStripeBalance(completionHandler: (JSON?, NSError?) -> ()) {
        makeStripeCall("/v1/stripe/balance", completionHandler: completionHandler)
    }
    
    func makeStripeCall(endpoint: String, completionHandler: (JSON?, NSError?) -> ()) {

        // check for token, get profile id based on token and make the request
        if(userAccessToken != nil) {
            loadUserProfile({ (item, error) in
                if error != nil {
                    print(error)
                }
                print(item)
                // TODO: Make secret key call from API, find user by ID
                if let userId = item?.id {
                    
                    let parameters : [String : AnyObject] = [
                        "userId": userId
                    ]
                    
                    print("parameters are", parameters)
                    
                    let headers = [
                        "Authorization": "Bearer " + (userAccessToken as! String),
                        "Content-Type": "application/json"
                    ]
                    
                    Alamofire.request(.POST, apiUrl + endpoint,
                        encoding:.JSON,
                        parameters: parameters,
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
            })
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
//        print(userData)
//        print(NSUserDefaults.valueForKey("userLoggedIn"))
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
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
//        print(userData)
        print(NSUserDefaults.valueForKey("userLoggedIn"))

        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Light)
        HUD.textLabel.text = "Logging out"
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.3)
        
        // go to login view
        self.performSegueWithIdentifier("loginView", sender: self);
        
    }
    
    // MARK: BEM Graph Delegate Methods
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return Int(self.arrayOfValues.count)
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(self.arrayOfValues[index] as! NSNumber)
    }
    
    // MARK: TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountHistoryArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        var CellIdentifier: String = "Cell"
//        let cell = tableView.dequeueReusableCellWithIdentifier(, forIndexPath: indexPath)
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier)


        let item = self.accountHistoryArray?[indexPath.row]
//        print("got data for account cells")
//        print(item)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = "Account credited"
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        if let text = item?.amount
        {
            cell.textLabel?.text = "$" + String(format: "%.2f", Double(text)!/100)
            cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 14)
            cell.textLabel?.textColor = UIColor.darkGrayColor()

        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
}

extension UISegmentedControl {
    func removeBorders() {
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Avenir-Book", size: 12)!],
            forState: .Normal)
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 18)!],
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
