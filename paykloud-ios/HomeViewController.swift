
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
//import MXParallaxHeader

class HomeViewController: UIViewController, UITableViewDataSource, CardIOPaymentViewControllerDelegate {
    
    
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
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var username: UILabel!
//    @IBOutlet weak var accountBalanceTextLabel: UILabel!

    
//    lazy var blurView: UIVisualEffectView = {
//        let blurView = UIVisualEffectView()
//        return blurView
//    }()
    
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
    
//    @IBOutlet weak var resultLabel: UILabel!

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
//        resultLabel.text = "Card not entered"
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
//            resultLabel.text = str as String
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        // Programatically setup left navigation button
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: "presentLeftMenuViewController")
        
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
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
//        var mainSegment: UISegmentedControl = UISegmentedControl(items: ["Available", "Pending"])
//        self.navigationItem.titleView = mainSegment
//        mainSegment.selectedSegmentIndex = 0
//        mainSegment.tintColor = UIColor.whiteColor()
//        mainSegment.addTarget(self, action: "mainSegmentControl:", forControlEvents: .ValueChanged)
//        self.navigationController?.navigationBar
//            .addSubview(mainSegment)
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("chargeButtonTapped:")), animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        // Blur View
//        blurView.addSubview(avatarImageView)
        
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
        return UIStatusBarStyle.Default
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
//        blurView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: blurViewHeight)
        
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
            print("user not logged in")
            // Normally identifiers are started with capital letters, exception being authViewController, make sure UIStoryboard name is Auth, not Main
            let viewController:AuthViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("authViewController") as! AuthViewController
            self.presentViewController(viewController, animated: true, completion: nil)
            SVProgressHUD.dismiss()
        } else {

            if userData != nil {
                print("user data exists")
            }
            
            print("user logged in, displaying home view")
            SVProgressHUD.dismiss()
            layoutFrames()
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
        
            
            // Otherwise if no local data exists get the user data after logging in
            // if(userData?["user"].stringValue != nil) {
            //    let headers = [
            //        "Authorization": "Bearer " + (userData?["user"]["stripeToken"].stringValue)!,
            //        "Content-Type": "application/x-www-form-urlencoded"
            //    ]
            //    
            //
            //    usernameViewText.text = userData?["user"]["username"].stringValue
            // }
            // if(userData?["user"]["username"].stringValue != nil) {
            //    usernameViewText.text = userData?["user"]["username"].stringValue
            // }
            // if(userData?["user"]["picture"]["secureUrl"].stringValue != nil) {
            //    let userPicture = userData?["user"]["picture"]["secureUrl"].stringValue
            //    let pictureUrl = NSURL(string: userPicture!)
            //    let data = NSData(contentsOfURL: pictureUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            //    if(data != nil) {
            //        self.avatarImageView.image = UIImage(data: data!)
            //        //self.avatarImageView.layer.cornerRadius = 4;
            //        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
            //        avatarImageView.layer.borderWidth = 2.0
            //        //self.avatarImageView.clipsToBounds = YES;
            //        SVProgressHUD.dismiss()
            //    } else {
            //        self.avatarImageView.image = UIImage(named:"IconUser")
            //        // self.avatarImageView.image = UIImageView.setGravatar(Gravatar)
            //        SVProgressHUD.dismiss()
            //    }
            //    //print(userData)
            // }

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
        self.performSegueWithIdentifier("loginView", sender: self);
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