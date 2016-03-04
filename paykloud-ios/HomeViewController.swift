
//
//  ViewController.swift
//  paykloud-ios
//
//  Created by Sinan Ulkuatam on 2/9/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import Neon
import Firebase
import SwiftyJSON
import Stripe
import MXParallaxHeader
import LiquidFloatingActionButton

class HomeViewController: UIViewController, UITableViewDataSource, CardIOPaymentViewControllerDelegate, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate {
    
    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    
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
    
    // INIT UI
    var button: StarButton! = nil
    @IBOutlet weak var logsTable: UITableView!    
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var accountBalanceTextLabel: UILabel!
    
    lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        return blurView
    }()

    // In order to add a button, such as a ui view, add the referencing iboutlet and then delete it, replacing it with the lazy loaded variable button type you see below
    lazy var scanCardButton: UIButton = {
        let scanCardButton = UIButton()
        return scanCardButton
    }()
    
    lazy var passcodeLockButton: UIButton = {
        let passcodeLockButton = UIButton()
        return passcodeLockButton
    }()
    
    lazy var applePayButton: UIButton = {
        let applePayButton = UIButton()
        return applePayButton
    }()


    // SET UP NEON VIEWS
    let containerView : UIView = UIView()
    let anchorView : UIView = UIView()
    let avatarImageView : UIImageView = UIImageView()
    let view0 : UILabel = UILabel()
    let usernameViewText : UILabel = UILabel()
    let view2 : UILabel = UILabel()
    
    @IBOutlet weak var resultLabel: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CARD IO
    @IBAction func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.hideCardIOLogo = true
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        resultLabel.text = "Card not entered"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didScanCard(cardInfo: CardIOCreditCardInfo) {
            // The full card number is available as info.cardNumber, but don't log that!
            print("Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", cardInfo.redactedCardNumber, cardInfo.expiryMonth, cardInfo.expiryYear, cardInfo.cvv);
            // Use the card info...
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        print("user did provide info")
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            resultLabel.text = str as String
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        if(index == 0) {
            print("index 0 tapped")
        } else if(index == 1) {
            print("index 1 tapped")
        } else if(index == 2) {
            // Show Card View
            scanCard(LiquidFloatingActionButton)
            print("index 2 tapped")
        }
//        print("did Tapped! \(index)")
        liquidFloatingActionButton.close()
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        // Programatically setup left navigation button
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "presentLeftMenuViewController")
        
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        // Header
        var headerView: UIImageView = UIImageView()
        headerView.image = UIImage(named: "Background")
        headerView.contentMode = .ScaleAspectFill
        var scrollView: UIScrollView = UIScrollView()
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 150
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
        scrollView.parallaxHeader.minimumHeight = 20

        
        // Load CardIO
        CardIOUtilities.preload()
        
        // Set up container
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.clearColor()
        view.addSubview(containerView)
        
        anchorView.backgroundColor = UIColor.clearColor()
        containerView.addSubview(anchorView)
        
        view0.backgroundColor = UIColor.blueColor()
        containerView.addSubview(view0)
        
        // Welcome text
        usernameViewText.backgroundColor = UIColor.clearColor()
        //        usernameViewText.text = "Welcome"
        usernameViewText.font = UIFont.boldSystemFontOfSize(20)
        usernameViewText.font = UIFont (name: "Avenir-Light", size: 30)
        usernameViewText.textColor = UIColor.blackColor()
        usernameViewText.textAlignment = .Center;
        //        containerView.addSubview(usernameViewText)
        
        // Style user avatar
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.layer.cornerRadius = 1.0
        avatarImageView.layer.borderColor = UIColor.blackColor().CGColor
        avatarImageView.clipsToBounds = true
        
        
        // Liquid Floating Button
        // self.view.backgroundColor = UIColor(red: 55 / 255.0, green: 55 / 255.0, blue: 55 / 255.0, alpha: 1.0)
        // Do any additional setup after loading the view, typically from a nib.
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (icon) in
            return LiquidFloatingCell(icon: UIImage(named: icon)!)
        }
        
        cells.append(cellFactory("ic_like"))
        cells.append(cellFactory("ic_skip"))
        cells.append(cellFactory("ic_koloda"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 56, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .Up)
        bottomRightButton.color = UIColor(rgba: "#1a8ef5")
        
        let floatingFrame2 = CGRect(x: 16, y: 16, width: 56, height: 56)
        // let topLeftButton = createButton(floatingFrame2, .Down)
        
        containerView.addSubview(bottomRightButton)
        containerView.bringSubviewToFront(bottomRightButton)
        
        // self.view.addSubview(topLeftButton)
        
        // Transparent navigation bar
        // self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#1a8ef5")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.topItem?.title = "PayKloud"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Nunito-SemiBold", size: 18.0)!
        ]
        
        // For creating segment control in navigation bar
        var mainSegment: UISegmentedControl = UISegmentedControl(items: ["Available", "Pending"])
        self.navigationItem.titleView = mainSegment
        mainSegment.selectedSegmentIndex = 0
        mainSegment.tintColor = UIColor.whiteColor()
        mainSegment.addTarget(self, action: "mainSegmentControl:", forControlEvents: .ValueChanged)
        self.navigationController?.navigationBar
            .addSubview(mainSegment)
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("chargeButtonTapped:")), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        // Blur View
        blurView.addSubview(avatarImageView)
        
        // Configure fancy button
        self.button = StarButton(frame: CGRectMake(133, 133, 54, 54))
        self.button.addTarget(self, action: "favorite:", forControlEvents:.TouchUpInside)
        // self.view.addSubview(button)
        self.view.addSubview(scanCardButton)
        self.view.addSubview(applePayButton)
        self.view.addSubview(passcodeLockButton)
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
    
    // LAYOUT SUBVIEWS
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Static container
        //
        containerView.fillSuperview(left: 0, right: 0, top: 30, bottom: 0)
        anchorView.anchorToEdge(.Top, padding: 20, width: 75, height: 75)
        
        layoutFrames()
    }
    
    // LAYOUT FRAMES
    func layoutFrames() {
        // BE SURE ALL UI ELEMENTS ARE ANCHORED ON THE PAGE, OTHERWISE FUNCTIONS WILL NOT EXECUTE
        // Adjust blurview size on storyboard below ui image view
        let blurViewHeight : CGFloat = view.height * 0.43
        blurView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: blurViewHeight)
        
        let avatarSize = CGFloat(1.0 * 75)
        
        avatarImageView.anchorToEdge(.Top, padding: 70, width: avatarSize, height: avatarSize)
        
//        button.anchorToEdge(.Bottom, padding: 10, width: 30, height: 30)
        
        scanCardButton.anchorToEdge(.Bottom, padding: 10, width: 30, height: 30)
        
        applePayButton.anchorToEdge(.Bottom, padding: 10, width: 30, height: 30)

        passcodeLockButton.anchorToEdge(.Bottom, padding: 10, width: 30, height: 30)

        usernameViewText.align(.UnderCentered, relativeTo: avatarImageView, padding: 0, width: 300, height: 30)

        //containerView.groupAndAlign(group: .Horizontal, andAlign: .UnderMatchingLeft, views: [view2, view3, view4], relativeTo: usernameViewText, padding: 10, width: 60, height: 60)
        
    }

    // VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        
        // Check for user logged in key
        let userLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn");
        if(!userLoggedIn) {
            // check if user logged in, if not send to login
            print("not logged in")
            // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
            let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        } else {
//            print(userData)
            print("logged in")
            SVProgressHUD.dismiss()
            layoutFrames()
            // Check user local data in json format, prevent re-retrieviing data from the server

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            formatter.locale = NSLocale.currentLocale() // This is the default

            // Otherwise if no local data exists get the user data after logging in
            if(userData?["user"].stringValue != nil) {
                let headers = [
                    "Authorization": "Bearer " + (userData?["user"]["stripeToken"].stringValue)!,
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
                
                Alamofire.request(.GET, "https://api.stripe.com/v1/balance", headers: headers)
                    .responseJSON { response in
                        if let value = response.result.value {
                            let response = JSON(value)
                            let bal = response["pending"][0]["amount"]
                            var formattedBal: String {
                                if let formattedBal = formatter.stringFromNumber(Int(bal.stringValue)!/100) {
                                    self.accountBalanceTextLabel.text = formattedBal
                                    return formattedBal
                                }
                                return ""
                            }
                        }
                }
                usernameViewText.text = userData?["user"]["username"].stringValue
            }
            if(userData?["user"]["username"].stringValue != nil) {
                usernameViewText.text = userData?["user"]["username"].stringValue
            }
            if(userData?["user"]["picture"]["secureUrl"].stringValue != nil) {
                let userPicture = userData?["user"]["picture"]["secureUrl"].stringValue
                let pictureUrl = NSURL(string: userPicture!)
                let data = NSData(contentsOfURL: pictureUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data != nil) {
                    self.avatarImageView.image = UIImage(data: data!)
                    //self.avatarImageView.layer.cornerRadius = 4;
                    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
                    avatarImageView.layer.borderWidth = 2.0
                    //self.avatarImageView.clipsToBounds = YES;
                    SVProgressHUD.dismiss()
                } else {
                    self.avatarImageView.image = UIImage(named:"IconUser")
                    // self.avatarImageView.image = UIImageView.setGravatar(Gravatar)
                    SVProgressHUD.dismiss()
                }
                //print(userData)
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
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
        NSUserDefaults.standardUserDefaults().synchronize();
        SVProgressHUD.show()
        // go to login view
        self.performSegueWithIdentifier("loginView", sender: self);
        
    }
    
}

public class CustomCell : LiquidFloatingCell {
    var name: String = "sample"
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(view: UIView) {
        super.setupView(view)
        let label = UILabel()
        label.text = name
        label.textColor = UIColor.redColor()
        label.font = UIFont(name: "Helvetica-Neue", size: 12)
        addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(self).offset(-80)
            make.width.equalTo(75)
            make.top.height.equalTo(self)
        }
    }
}


