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
import LiquidFloatingActionButton
//import MXParallaxHeader

let userAccessToken = NSUserDefaults.standardUserDefaults().valueForKey("userAccessToken")

class HomeViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource,  LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate  {
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var arrayOfValues: Array<AnyObject> = []
    
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
        // Programatically setup left navigation button
        // Create a navigation item with a title
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        HUD.dismissAfterDelay(0.3)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        let frame = CGRectMake(0, 160, screenWidth, screenHeight-160)
        let graph: BEMSimpleLineGraphView = BEMSimpleLineGraphView(frame: frame)
        graph.dataSource = self
        graph.colorTop = UIColor.whiteColor()
        graph.colorBottom = UIColor.whiteColor()
        graph.colorLine = UIColor(rgba: "#157efb")
        graph.colorPoint = UIColor(rgba: "#157efb")
        graph.delegate = self
        graph.displayDotsWhileAnimating = true
        graph.enablePopUpReport = true
        graph.enableTouchReport = true
        graph.enableBezierCurve = true
        graph.layer.masksToBounds = true
        self.view!.addSubview(graph)

        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            floatingActionButton.color = UIColor(rgba: "#157efb")
            return floatingActionButton
        }
        
        let customCellFactory: (String, String, String) -> LiquidFloatingCell = { (iconName, description, segue) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: description, segue: segue)
            return cell
        }
        cells.append(customCellFactory("ic_like", "Create Charge", "chargeView"))
        cells.append(customCellFactory("ic_card_from_bg", "Add Plan", "addPlanView"))
        cells.append(customCellFactory("ic_skip", "Add Customer", "addCustomerView"))
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 116 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        print(bottomRightButton.isOpening.boolValue)
        print(bottomRightButton.isClosed.boolValue)

        if(bottomRightButton.isOpening.boolValue) {
            print("adding blurview")
            self.addBlurView()
        } else if(bottomRightButton.isClosed.boolValue) {
            print("button is closed")
            //                removeBlurView()
        }
        self.view.addSubview(bottomRightButton)
        
        let mainSegment: UISegmentedControl = UISegmentedControl(items: ["2W", "1M", "3M", "1Y", "5Y"])
        mainSegment.frame = CGRect(x: 15.0, y: 140.0, width: view.bounds.width - 30.0, height: 30.0)
        mainSegment.selectedSegmentIndex = 1
        mainSegment.removeBorders()
        mainSegment.addTarget(self, action: #selector(HomeViewController.mainSegmentControl(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(mainSegment)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: screenWidth, height: 50))
        navBar.barTintColor = UIColor(rgba: "#FFF")
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.protonBlue(),
            NSFontAttributeName : UIFont(name: "Nunito-Regular", size: 18)!
        ]
        
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Account Balance")
        navBar.setItems([navItem], animated: true)
        
        let runkeeperSwitch = DGRunkeeperSwitch(leftTitle: "Pending", rightTitle: "Available")
        runkeeperSwitch.backgroundColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.selectedBackgroundColor = .whiteColor()
        runkeeperSwitch.titleColor = .whiteColor()
        runkeeperSwitch.selectedTitleColor = UIColor(rgba: "#157efb")
        runkeeperSwitch.titleFont = UIFont(name: "Nunito-SemiBold", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 50.0, y: 78.0, width: view.bounds.width - 100.0, height: 30.0)
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
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor(rgba: "#157efb"),
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 18.0)!
        ]

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
    
    func chargeTapped(sender: AnyObject) {
        
    }
    
    func recurringTapped(sender: AnyObject) {
        
    }
    
    func addBlurView(){
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(blurView, aboveSubview: self.view)
    }
    
    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
        UITextField.appearance().keyboardAppearance = .Light

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

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale() // This is the default
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
    
    // Liquid Floating Button Delegate
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        if index == 0 {
            self.performSegueWithIdentifier("chargeView", sender: self)
        }
        if index == 1 {
            self.performSegueWithIdentifier("addPlanView", sender: self)
        }
        if index == 2 {
            self.performSegueWithIdentifier("addCustomerView", sender: self)
        }
        liquidFloatingActionButton.close()
    }
    
}

public class CustomCell : LiquidFloatingCell {
    var name: String = "sample"
    var segue: String = "sampleSegue"
    
    init(icon: UIImage, name: String, segue: String) {
        self.name = name
        self.segue = segue
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(view: UIView) {
        super.setupView(view)
        let label = UILabel()
        label.text = name
        label.textAlignment = .Right
        label.textColor = UIColor(rgba: "#004790")
        label.font = UIFont(name: "Nunito-Regular", size: 12)
        addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(self).offset(-120)
            make.width.equalTo(100)
            make.top.height.equalTo(self)
        }
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor(rgba: "#157efb"),
                NSFontAttributeName : UIFont(name: "Nunito-Regular", size: 12)!],
            forState: .Normal)
        setTitleTextAttributes(
            [NSForegroundColorAttributeName : UIColor(rgba: "#004790"),
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

public func makeRoundedImage(image: UIImage, radius: Float) -> UIImage {
    let imageLayer: CALayer = CALayer()
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
    imageLayer.contents = (image.CGImage as! AnyObject)
    imageLayer.masksToBounds = true
    imageLayer.cornerRadius = CGFloat(radius)
    UIGraphicsBeginImageContext(image.size)
    imageLayer.renderInContext(UIGraphicsGetCurrentContext()!)
    let roundedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage
}