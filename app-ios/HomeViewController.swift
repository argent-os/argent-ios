//
//  HomeViewController.swift
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

    private var window: UIWindow?

    private var dateFormatter = NSDateFormatter()

    private var accountHistoryArray:Array<History>?
    
    private var balance:Balance = Balance(pending: 0, available: 0)
    
    private var tableView:UITableView = UITableView()
    
    private var arrayOfValues: Array<AnyObject> = [30,10,20,50,60,80]
    
    private var user = User(id: "", username: "", email: "", first_name: "", last_name: "", picture: "")
    
    private let lblAccountPending:UICountingLabel = UICountingLabel()

    private let lblAccountAvailable:UICountingLabel = UICountingLabel()

    private let lblAvailableDescription:UILabel = UILabel()

    private let lblPendingDescription:UILabel = UILabel()
    
    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    private let balanceSwitch = DGRunkeeperSwitch(leftTitle: "Pending", rightTitle: "Available")

    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: UIScreen.mainScreen().bounds.size.width, height: 50))

    private let graph: BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.size.width, 190))
        
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
        
        definesPresentationContext = true

        configureView()
        
        loadData()
    }
    
    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        self.view.addSubview(balanceSwitch)
        self.view.bringSubviewToFront(balanceSwitch)
        UITextField.appearance().keyboardAppearance = .Light
        UIStatusBarStyle.LightContent
        
    }
    
    func presentTutorial(sender: AnyObject) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TutorialHomeViewController") as! TutorialHomeViewController
        viewController.alpha = 0.5
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        balanceSwitch.removeFromSuperview()
    }
    
    func dateRangeSegmentControl(segment: UISegmentedControl) {
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
    
    func loadData() {
        
        // IMPORTANT: load new access token on home load, otherwise the old token will be requested to the server
        userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        if((userAccessToken) != nil) {
            // Get stripe data
            loadStripe({ (balance, err) in
                
                let pendingBalance = balance.pending
                let availableBalance = balance.available
                
                NSNotificationCenter.defaultCenter().postNotificationName("balance", object: nil, userInfo: ["available_bal":availableBalance,"pending_bal":pendingBalance])

                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                formatter.locale = NSLocale.currentLocale() // This is the default
                
                if(pendingBalance != 0 && availableBalance != 0) {
                    self.lblAccountPending.countFrom(CGFloat(pendingBalance)/100-600, to: CGFloat(pendingBalance)/100)
                    self.lblAccountPending.textColor = UIColor.whiteColor()
                    self.lblAccountPending.format = "%.2f"
                    self.lblAccountPending.animationDuration = 0.5
                    self.lblAccountPending.method = UILabelCountingMethod.EaseInOut
                    self.lblAccountPending.completionBlock = {
                        let pendingBalanceNum = formatter.stringFromNumber(pendingBalance/100)
                        self.lblAccountPending.text = pendingBalanceNum
                    }
    
                    self.lblAccountAvailable.countFrom((CGFloat(Float(availableBalance))/100)-100, to: CGFloat(Float(availableBalance))/100)
                    self.lblAccountAvailable.textColor = UIColor.whiteColor()
                    self.lblAccountAvailable.format = "%.2f"
                    self.lblAccountAvailable.animationDuration = 1.0
                    self.lblAccountAvailable.method = UILabelCountingMethod.EaseInOut
                    self.lblAccountAvailable.completionBlock = {
                        let availableBalanceNum = formatter.stringFromNumber(availableBalance/100)
                        self.lblAccountAvailable.text = availableBalanceNum
                    }
                }
            })
            
            // Get user account history
            loadAccountHistory { (historyArr, error) in
                if error != nil {
                    print(error)
                }
                self.activityIndicator.stopAnimating()
            }
            
            // Get user profile
            loadUserProfile { (user, error) in
                
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(20, 31, 40, 40))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.layer.borderWidth = 2
                userImageView.layer.borderColor = UIColor(rgba: "#fffa").CGColor
                
                if user?.picture != nil && user?.picture != "" {
                    Timeout(0.5) {
                        let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user?.picture)!)!)!)!
                        userImageView.image = img
                        self.view.addSubview(userImageView)
                    }
                } else {
                    if user?.username == nil || user?.username == "" {
                        // logout on failure to get profile
                        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userAccessToken")
                        NSUserDefaults.standardUserDefaults().synchronize();
                        userData = nil
                        
                        // go to login view
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
                            root!.presentViewController(loginVC, animated: false, completion: { () -> Void in
                        })
                    }
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
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let img: UIImage = UIImage(named: "Logo")!
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
        let bg: UIImageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        bg.contentMode = .ScaleAspectFill
        bg.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        bg.layer.masksToBounds = true
        bg.clipsToBounds = true
        bg.backgroundColor = UIColor.slateBlue()
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)

        graph.dataSource = self
        graph.colorTop = UIColor.clearColor()
        graph.colorBottom = UIColor.slateBlue()
//        graph.colorLine = UIColor(rgba: "#0003")
        graph.colorLine = UIColor.brandYellow()
        graph.colorPoint = UIColor.yellowColor()
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
        
        let dateRangeSegment: UISegmentedControl = UISegmentedControl(items: ["1M", "3M", "6M", "1Y", "5Y"])
        dateRangeSegment.frame = CGRect(x: 15.0, y: 230.0, width: view.bounds.width - 30.0, height: 30.0)
        //        var y_co: CGFloat = self.view.frame.size.height - 100.0
        //        dateRangeSegment.frame = CGRectMake(10, y_co, width-20, 50.0)
        dateRangeSegment.selectedSegmentIndex = 2
        dateRangeSegment.removeBorders()
        dateRangeSegment.addTarget(self, action: #selector(HomeViewController.dateRangeSegmentControl(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(dateRangeSegment)
        
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
        
        balanceSwitch.backgroundColor = UIColor.clearColor()
        balanceSwitch.selectedBackgroundColor = UIColor.darkBlue().colorWithAlphaComponent(0.5)
        balanceSwitch.titleColor = UIColor.whiteColor()
        balanceSwitch.selectedTitleColor = UIColor.whiteColor()
        balanceSwitch.titleFont = UIFont(name: "Avenir-Book", size: 12.0)
        balanceSwitch.frame = CGRect(x: view.bounds.width - 185.0, y: 30, width: 180, height: 35.0)
        //autoresizing so it stays at top right (flexible left and flexible bottom margin)
        balanceSwitch.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        balanceSwitch.bringSubviewToFront(balanceSwitch)
        balanceSwitch.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), forControlEvents: .ValueChanged)
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40))
        headerView.backgroundColor = UIColor.clearColor()
        let headerViewTitle: UILabel = UILabel()
        headerViewTitle.frame = CGRect(x: 18, y: 15, width: screenWidth, height: 30)
        headerViewTitle.text = "Transaction History"
        headerViewTitle.font = UIFont(name: "Avenir-Light", size: 16)
        headerViewTitle.textAlignment = .Left
        headerViewTitle.textColor = UIColor.lightGrayColor()
        headerView.addSubview(headerViewTitle)
        
        let tutorialButton:UIButton = UIButton()
        tutorialButton.frame = CGRect(x: screenWidth-40, y: 22, width: 22, height: 22)
        tutorialButton.setImage(UIImage(named: "ic_question"), forState: .Normal)
        tutorialButton.setTitle("Tuts", forState: .Normal)
        tutorialButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        tutorialButton.addTarget(self, action: #selector(HomeViewController.presentTutorial(_:)), forControlEvents: .TouchUpInside)
        tutorialButton.addTarget(self, action: #selector(HomeViewController.presentTutorial(_:)), forControlEvents: .TouchUpOutside)
        headerView.addSubview(tutorialButton)
        headerView.bringSubviewToFront(tutorialButton)
        
        tableView.frame = CGRect(x: 0, y: 270, width: screenWidth, height: screenHeight-315)
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
        loadingView.tintColor = UIColor.brandYellow()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self?.tableView.dg_stopLoading()
                    self?.loadAccountHistory({ (_: [History]?, NSError) in
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
        History.getAccountHistory({ (transactions, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load history \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.accountHistoryArray = transactions
            completionHandler(transactions!, error)
            self.tableView.reloadData()
        })
    }
    
    func loadStripe(completionHandler: (Balance, NSError?) -> ()) {
        // Set account balance label
        
        Balance.getStripeBalance({ (balance, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load history \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.balance = balance!
            completionHandler(balance!, error)
        })
    }
    
    func loadUserProfile(completionHandler: (User?, NSError?) -> ()) {
        User.getProfile({ (user, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.user = user!
            completionHandler(user!, error)
        })
    }

    // LOGOUT
    func logout() {
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userAccessToken")
        NSUserDefaults.standardUserDefaults().synchronize();
        userData = nil

        // go to login view
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController")
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        root!.presentViewController(loginVC, animated: false, completion: { () -> Void in
        })
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        userData = nil
        
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
        self.tableView.registerNib(UINib(nibName: "HistoryCustomCell", bundle: nil), forCellReuseIdentifier: "idCellCustomHistory")

        let cell = self.tableView.dequeueReusableCellWithIdentifier("idCellCustomHistory") as! HistoryCustomCell

        let item = self.accountHistoryArray?[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lblAmount?.text = ""
        cell.lblDate?.text = ""
        if let amount = item?.amount {
            if Double(amount)!/100 < 0 {
                cell.lblCreditDebit?.text = "Account debit"
                cell.lblAmount?.textColor = UIColor.brandRed()
            } else {
                cell.lblCreditDebit?.text = "Account credit"
                cell.lblAmount?.textColor = UIColor.brandGreen()
            }
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            // formatter.locale = NSLocale.currentLocale() // This is the default
            let amt = formatter.stringFromNumber(Float(amount)!/100)
            cell.lblAmount?.text = amt!
        }
        if let date = item?.created
        {
            if(!date.isEmpty || date != "") {
                let converted_date = NSDate(timeIntervalSince1970: Double(date)!)
                dateFormatter.dateStyle = .MediumStyle
                let formatted_date = dateFormatter.stringFromDate(converted_date)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                cell.lblDate?.text = String(formatted_date) //+ " / uid " + uid
            } else {
                
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // self.performSegueWithIdentifier("historyDetailView", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
}