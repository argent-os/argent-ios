//
//  ProfileMenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SafariServices
import DGElasticPullToRefresh
import CWStatusBarNotification
import StoreKit
import Crashlytics
import Whisper

class ProfileMenuViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    @IBOutlet weak var shareCell: UITableViewCell!

    @IBOutlet weak var rateCell: UITableViewCell!
    
    private var userImageView: UIImageView = UIImageView()

    private var scrollView: UIScrollView!

    private var notification = CWStatusBarNotification()

    private var customersArray = [Customer]()
    
    private var plansArray = [Plan]()

    private var subscriptionsArray = [Subscription]()

    private var customersCountLabel = UILabel()
    
    private var plansCountLabel = UILabel()

    private var subscriptionsCountLabel = UILabel()

    private var locationLabel = UILabel()

    private var splitter = UIView()

    private var splitter2 = UIView()

    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.size.width, height: 50))

    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHeader()
        validateAccount()
    }
    
    func validateAccount() {
        Account.getStripeAccount { (acct, err) in
            
            let fields = acct?.verification_fields_needed
            let _ = fields.map { (unwrappedOptionalArray) -> Void in
                
                // if array has values
                if !unwrappedOptionalArray.isEmpty {
                    let fields_required: [String] = unwrappedOptionalArray
                    let fields_list = fields_required.dropLast().reduce("") { $0 + $1 + ", " } + fields_required.last!
                    
                    // regex to replace legal.entity in the future
                    
                    var announcement = Announcement(title: "Profile Incomplete | Require info", subtitle:
                        fields_list, image: UIImage(named: "IconAlert"))
                    announcement.duration = 7
                    Shout(announcement, to: self)
                    
                    let _ = Timeout(10) {
                        if acct?.transfers_enabled == false {
                            showGlobalNotification("Transfers disabled until more account information is provided", duration: 10.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.iosBlue())
                        }
                    }
                }
            }
        }
    }
    
    func configureView() {
        
        self.view.backgroundColor = UIColor.globalBackground()        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        self.view.bringSubviewToFront(tableView)
        self.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 220));
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.frame = CGRect(x: 0, y: 100, width: screenWidth, height: 100)
        loadingView.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
                self!.loadProfile()
                self!.configureHeader()
                self!.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self!.view.bounds), 220));
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.clearColor())
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.clearColor())
        
        loadProfile()
        
        // Add action to share cell to return to activity menu
        shareCell.targetForAction(Selector("share:"), withSender: self)
        
        // Add action to rate cell to return to activity menu
        let rateGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openStoreProductWithiTunesItemIdentifier(_:)))
        rateCell.addGestureRecognizer(rateGesture)
    }
    
    func openStoreProductWithiTunesItemIdentifier(sender: AnyObject) {
        showGlobalNotification("Loading App Store", duration: 1, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.mediumBlue())
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : APP_ID]
        storeViewController.loadProductWithParameters(parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewController
                self?.presentViewController(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func configureHeader() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
//         let settingsIcon = UIImageView(frame: CGRectMake(0, 0, 22, 22))
//         settingsIcon.image = UIImage(named: "IconSettingsWhite")
//         settingsIcon.contentMode = .ScaleAspectFit
//         settingsIcon.alpha = 0.5
//         settingsIcon.center = CGPointMake(self.view.frame.size.width-25, -10)
//         settingsIcon.userInteractionEnabled = true
//         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.goToEdit(_:)))
//         tap.numberOfTapsRequired = 1
//         settingsIcon.addGestureRecognizer(tap)
//         self.view.addSubview(settingsIcon)
//         self.view.bringSubviewToFront(settingsIcon)
        
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "IconPinWhiteTiny")
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        Account.getStripeAccount { (acct, err) in
            if let address_city = acct?.address_city where address_city != "", let address_country = acct?.address_country {
                let locationStr: NSMutableAttributedString = NSMutableAttributedString(string: address_city + ", " + address_country)
                locationStr.appendAttributedString(attachmentString)
                self.locationLabel.attributedText = locationStr
                let _ = Timeout(0.2) {
                    addSubviewWithFade(self.locationLabel, parentView: self, duration: 0.8)
                }
            } else if let address_city = acct?.address_city, let address_country = acct?.address_country {
                let locationStr: NSMutableAttributedString = NSMutableAttributedString(string: "Unknown, " + address_country)
                    locationStr.appendAttributedString(attachmentString)
                    self.locationLabel.attributedText = locationStr
                    let _ = Timeout(0.2) {
                        addSubviewWithFade(self.locationLabel, parentView: self, duration: 0.8)
                }
            } else {
                let locationStr: NSMutableAttributedString = NSMutableAttributedString(string: "Unknown")
                locationStr.appendAttributedString(attachmentString)
                self.locationLabel.attributedText = locationStr
                let _ = Timeout(0.2) {
                    addSubviewWithFade(self.locationLabel, parentView: self, duration: 0.8)
                }
                showGlobalNotification("Profile Incomplete", duration: 2.5, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.brandYellow())
            }
        }
        self.locationLabel.frame = CGRectMake(0, 72, screenWidth, 70)
        self.locationLabel.textAlignment = NSTextAlignment.Center
        self.locationLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.locationLabel.numberOfLines = 0
        self.locationLabel.textColor = UIColor(rgba: "#fff")

        splitter.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        splitter.frame = CGRect(x: screenWidth*0.333-0.5, y: 140, width: 1, height: 50)
        let _ = Timeout(0.05) {
            addSubviewWithFade(self.splitter, parentView: self, duration: 1.2)
        }
        
        splitter2.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        splitter2.frame = CGRect(x: screenWidth*0.666-0.5, y: 140, width: 1, height: 50)
        let _ = Timeout(0.1) {
            addSubviewWithFade(self.splitter2, parentView: self, duration: 1.2)
        }
        
        self.subscriptionsCountLabel.frame = CGRectMake(30, 130, 80, 70)
        self.subscriptionsCountLabel.textAlignment = NSTextAlignment.Center
        self.subscriptionsCountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.subscriptionsCountLabel.numberOfLines = 0
        self.subscriptionsCountLabel.textColor = UIColor(rgba: "#fff")
        
        self.customersCountLabel.frame = CGRectMake(screenWidth*0.5-40, 130, 80, 70)
        self.customersCountLabel.textAlignment = NSTextAlignment.Center
        self.customersCountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.customersCountLabel.numberOfLines = 0
        self.customersCountLabel.textColor = UIColor(rgba: "#fff")
        
        self.plansCountLabel.frame = CGRectMake(screenWidth-110, 130, 80, 70)
        self.plansCountLabel.textAlignment = NSTextAlignment.Center
        self.plansCountLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.plansCountLabel.numberOfLines = 0
        self.plansCountLabel.textColor = UIColor(rgba: "#fff")
    }
    
    func reloadUserData() {
        self.loadCustomerList { (customers: [Customer]?, NSError) in
            if(customers!.count == 0) {
                self.customersCountLabel.text = "No customers"
            } else if(customers!.count < 2 && customers!.count > 0) {
                self.customersCountLabel.text = String(customers!.count) + "\ncustomer"
            } else if(customers!.count > 98) {
                self.customersCountLabel.text = "100+\ncustomers"
            } else {
                self.customersCountLabel.text = String(customers!.count) + "\ncustomers"
            }
            let _ = Timeout(0.3) {
                addSubviewWithFade(self.customersCountLabel, parentView: self, duration: 0.8)
            }
        }
        
        self.loadPlanList("100", starting_after: "") { (plans, error) in
            if(plans!.count == 0) {
                self.plansCountLabel.text = "No plans"
            } else if(plans!.count < 2 && plans!.count > 0) {
                self.plansCountLabel.text = String(plans!.count) + "\nplan"
            } else if(plans!.count > 98) {
                self.plansCountLabel.text = "100+\nplans"
            } else {
                self.plansCountLabel.text = String(plans!.count) + "\nplans"
            }
            let _ = Timeout(0.3) {
                addSubviewWithFade(self.plansCountLabel, parentView: self, duration: 0.8)
            }
        }
        
        self.loadSubscriptionList { (subscriptions: [Subscription]?, NSError) in
            if(subscriptions!.count == 0) {
                self.subscriptionsCountLabel.text = "No subs"
            } else if(subscriptions!.count < 2 && subscriptions!.count > 0) {
                self.subscriptionsCountLabel.text = String(subscriptions!.count) + "\nsubscription"
            } else if(subscriptions!.count > 98) {
                self.subscriptionsCountLabel.text = "100+\nsubscriptions"
            } else {
                self.subscriptionsCountLabel.text = String(subscriptions!.count) + "\nsubscriptions"
            }
            let _ = Timeout(0.3) {
                addSubviewWithFade(self.subscriptionsCountLabel, parentView: self, duration: 0.8)
            }
        }
    }
    
    // Sets up nav
    func configureNav(user: User) {
        let navItem = UINavigationItem()

        // TODO: do a check for first name, and business name
        let f_name = user.first_name
        let l_name = user.last_name
        let u_name = user.username
        let b_name = user.business_name
        print(b_name)
        if b_name != "" {
            navItem.title = b_name
        } else if f_name != "" {
            navItem.title = f_name + " " + l_name
        } else {
            navItem.title = u_name
        }
        
        self.navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        ]
        self.navBar.setItems([navItem], animated: false)
        let _ = Timeout(0.1) {
            addSubviewWithFade(self.navBar, parentView: self, duration: 0.8)
        }
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Handles share and logout action controller
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)!.tag == 865) {
        
            
            // share action controller
            let activityViewController  = UIActivityViewController(
                    activityItems: ["Check out this app!  https://www.argentapp.com/home" as NSString],
                    applicationActivities: nil)
                if activityViewController.userActivity?.activityType == UIActivityTypePostToFacebook {
                    let uuid = NSUUID().UUIDString
                    Answers.logShareWithMethod("FaceBook",
                                               contentName: "User sharing to Facebook",
                                               contentType: "facebook",
                                               contentId: uuid,
                                               customAttributes: nil)
                } else if activityViewController.userActivity?.activityType == UIActivityTypePostToTwitter {
                    let uuid = NSUUID().UUIDString
                    Answers.logShareWithMethod("Twitter",
                                               contentName: "User sharing to Twitter",
                                               contentType: "twitter",
                                               contentId: uuid,
                                               customAttributes: nil)
                } else if activityViewController.userActivity?.activityType == UIActivityTypeMessage {
                    let uuid = NSUUID().UUIDString
                    Answers.logShareWithMethod("Message",
                                               contentName: "User sharing through message",
                                               contentType: "message",
                                               contentId: uuid,
                                               customAttributes: nil)
                } else if activityViewController.userActivity?.activityType == UIActivityTypeMail {
                    let uuid = NSUUID().UUIDString
                    Answers.logShareWithMethod("Mail",
                                               contentName: "User sharing through mail",
                                               contentType: "mail",
                                               contentId: uuid,
                                               customAttributes: nil)
                }
            
            activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                presentViewController(activityViewController, animated: true, completion: nil)
            activityViewController.popoverPresentationController?.sourceView = UIView()
            activityViewController.popoverPresentationController?.sourceRect = UIView().bounds
        }
        
        if(tableView.cellForRowAtIndexPath(indexPath)!.tag == 534) {
            // 1
            let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
            optionMenu.popoverPresentationController?.sourceView = UIView()
            optionMenu.popoverPresentationController?.sourceRect = UIView().bounds
            // 2
            let logoutAction = UIAlertAction(title: "Logout", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setValue("", forKey: "userAccessToken")
                NSUserDefaults.standardUserDefaults().synchronize();
                
                Answers.logCustomEventWithName("User logged out from profile",
                    customAttributes: [:])
                
                // go to login view
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                loginVC.modalTransitionStyle = .CrossDissolve
                let root = UIApplication.sharedApplication().keyWindow?.rootViewController
                root!.presentViewController(loginVC, animated: true, completion: { () -> Void in })
            })
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            // 4
            optionMenu.addAction(logoutAction)
            optionMenu.addAction(cancelAction)
            // 5
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    // Loads profile and sets picture
    func loadProfile() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileMenuViewController.goToEditPicture(_:)))
        
        userImageView.frame = CGRectMake(screenWidth / 2, -64, 60, 60)
        userImageView.layer.cornerRadius = 30
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        // centers user profile image
        userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 10)
        userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor(rgba: "#fff").colorWithAlphaComponent(0.3).CGColor
        
        User.getProfile({ (user, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            self.configureNav(user!)
            
            if user!.picture != "" {
                let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user!.picture))!)!)!
                self.userImageView.image = img
                addSubviewWithFade(self.userImageView, parentView: self, duration: 0.8)
            } else {
                let img = UIImage(named: "IconCamera")
                self.userImageView.image = img
                addSubviewWithFade(self.userImageView, parentView: self, duration: 0.8)
            }
        })
        
        reloadUserData()
    }
    
    // Opens edit picture
    func goToEditPicture(sender: AnyObject) {
        self.performSegueWithIdentifier("profilePictureView", sender: sender)
    }
    
    // Opens edit picture
    func goToEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileView", sender: sender)
    }
    
    // Load user data lists for customer and plan
    private func loadCustomerList(completionHandler: ([Customer]?, NSError?) -> ()) {
        Customer.getCustomerList("100", starting_after: "", completionHandler: { (customers, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load customers \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.customersArray = customers!
            completionHandler(customers!, error)
        })
    }
    
    private func loadPlanList(limit: String, starting_after: String, completionHandler: ([Plan]?, NSError?) -> ()) {
        Plan.getPlanList(limit, starting_after: starting_after, completionHandler: { (plans, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.plansArray = plans!
            completionHandler(plans!, error)
        })
    }
    
    private func loadSubscriptionList(completionHandler: ([Subscription]?, NSError?) -> ()) {
        Subscription.getSubscriptionList({ (subscriptions, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not load subscriptions \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.subscriptionsArray = subscriptions!
            completionHandler(subscriptions!, error)
        })
    }
    
    // User profile image view scroll effects
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
        headerView.scrollViewDidScroll(scrollView)
    }
}