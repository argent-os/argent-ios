//
//  ProfileMenuViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import SafariServices
import CWStatusBarNotification
import StoreKit
import Crashlytics
import Whisper
import MZFormSheetPresentationController
import KeychainSwift

class ProfileMenuViewController: UITableViewController, SKStoreProductViewControllerDelegate {
    
    @IBOutlet weak var shareCell: UITableViewCell!

    @IBOutlet weak var rateCell: UITableViewCell!
    
    @IBOutlet weak var inviteCell: UITableViewCell!
    
    private var menuSegmentBar: UISegmentedControl = UISegmentedControl(items: ["Account", "More"])

    private var shouldShowSection1: Bool? = true
    
    private var shouldShowSection2: Bool? = false
    
    private var maskHeaderView = UIView()

    private var verifiedLabel = UILabel()

    private var verifiedImage = UIImageView()

    private var verifiedButton:UIButton = UIButton()

    private var userImageView: UIImageView = UIImageView()

    private var scrollView: UIScrollView!

    private var notification = CWStatusBarNotification()

    private var locationLabel = UILabel()
    
    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.size.width, height: 50))
    
    private let refreshControlView = UIRefreshControl()

    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHeader()
        validateAccount()
    }
    
    func validateAccount() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let app: UIApplication = UIApplication.sharedApplication()
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusBarView: UIView = UIView(frame: CGRectMake(0, -statusBarHeight, UIScreen.mainScreen().bounds.size.width, statusBarHeight))
        statusBarView.backgroundColor = UIColor.clearColor()
        self.navigationController?.navigationBar.addSubview(statusBarView)
        
        self.verifiedLabel.contentMode = .Center
        self.verifiedLabel.textAlignment = .Center
        self.verifiedLabel.textColor = UIColor.darkBlue()
        self.verifiedLabel.font = UIFont(name: "SFUIText-Regular", size: 14)
        self.verifiedLabel.layer.cornerRadius = 5
        self.verifiedLabel.layer.borderColor = UIColor.darkBlue().CGColor
        self.verifiedLabel.layer.borderWidth = 0
        let verifyTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showTutorialModal(_:)))
        self.verifiedLabel.addGestureRecognizer(verifyTap)
        self.verifiedLabel.userInteractionEnabled = true
        self.view.addSubview(self.verifiedLabel)
        self.view.bringSubviewToFront(self.verifiedLabel)

        Account.getStripeAccount { (acct, err) in
            
            let fields = acct?.verification_fields_needed
            let _ = fields.map { (unwrappedOptionalArray) -> Void in
                
                // if array has values
                if !unwrappedOptionalArray.isEmpty {
                    self.verifiedLabel.text = "How to Verify?"
                    self.verifiedLabel.textColor = UIColor.iosBlue()
                    self.verifiedLabel.frame = CGRect(x: 110, y: 82, width: screenWidth-220, height: 30)
                    self.locationLabel.textAlignment = NSTextAlignment.Center
                    
                    var fields_required: [String] = unwrappedOptionalArray
                    if let indexOfExternalAccount = fields_required.indexOf("external_account") {
                        fields_required[indexOfExternalAccount] = "Bank"
                    }
                    if let indexOfFirstName = fields_required.indexOf("legal_entity.first_name") {
                        fields_required[indexOfFirstName] = "First Name"
                    }
                    if let indexOfLastName = fields_required.indexOf("legal_entity.last_name") {
                        fields_required[indexOfLastName] = "Last Name"
                    }
                    if let indexOfBusinessName = fields_required.indexOf("legal_entity.business_name") {
                        fields_required[indexOfBusinessName] = "Business Name"
                    }
                    if let indexOfAddressCity = fields_required.indexOf("legal_entity.address.city") {
                        fields_required[indexOfAddressCity] = "City"
                    }
                    if let indexOfAddressState = fields_required.indexOf("legal_entity.address.state") {
                        fields_required[indexOfAddressState] = "State"
                    }
                    if let indexOfAddressZip = fields_required.indexOf("legal_entity.address.postal_code") {
                        fields_required[indexOfAddressZip] = "ZIP"
                    }
                    if let indexOfAddressLine1 = fields_required.indexOf("legal_entity.address.line1") {
                        fields_required[indexOfAddressLine1] = "Address"
                    }
                    if let indexOfPIN = fields_required.indexOf("legal_entity.personal_id_number") {
                        fields_required[indexOfPIN] = "SSN or Personal ID Number"
                    }
                    if let indexOfSSNLast4 = fields_required.indexOf("legal_entity.ssn_last_4") {
                        fields_required[indexOfSSNLast4] = "SSN Information"
                    }
                    if let indexOfEIN = fields_required.indexOf("legal_entity.business_tax_id") {
                        fields_required[indexOfEIN] = "Business Tax ID (EIN)"
                    }
                    if let indexOfVerificationDocument = fields_required.indexOf("legal_entity.verification.document") {
                        fields_required[indexOfVerificationDocument] = "Verification Document"
                    }
                    
                    
                    let fields_list = fields_required.dropLast().reduce("") { $0 + $1 + ", " } + fields_required.last!
                    
                    // regex to replace legal.entity in the future
                    
                    var announcement = Announcement(title: "Identity verification incomplete", subtitle:
                        fields_list, image: UIImage(named: "IconAlertCalm"))
                    announcement.duration = 7
//                    Shout(announcement, to: self)
                    
                    let _ = Timeout(10) {
                        if acct?.transfers_enabled == false {
                            //showGlobalNotification("Transfers disabled until more account information is provided", duration: 10.0, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.StatusBarNotification, color: UIColor.oceanBlue())
                        }
                    }
                } else if let disabled_reason = acct?.verification_disabled_reason where acct?.verification_disabled_reason != "" {
                    self.locationLabel.removeFromSuperview()
                    self.verifiedLabel.layer.borderWidth = 0
                    self.verifiedLabel.frame = CGRect(x: 30, y: 100, width: screenWidth-60, height: 30)
                    self.view.addSubview(self.verifiedLabel)
                    if disabled_reason == "rejected.fraud" {
                        self.verifiedButton.removeFromSuperview()
                        self.verifiedLabel.text = "Account rejected: Fraud detected"
                    } else if disabled_reason == "rejected.terms_of_service" {
                        self.verifiedButton.removeFromSuperview()
                        self.verifiedLabel.text = "Account rejected: Terms of Service"
                    } else if disabled_reason == "rejected.other" {
                        self.verifiedButton.removeFromSuperview()
                        self.verifiedLabel.text = "Account rejected | Reason: Other"
                    } else if disabled_reason == "other" {
                        self.verifiedButton.removeFromSuperview()
                        self.verifiedLabel.text = "System maintenance, transfers disabled"
                    }
                }
            }
        }
    }
    
    func checkIfVerified(completionHandler: (Bool, NSError?) -> ()){
        Account.getStripeAccount { (acct, err) in
            let fields = acct?.verification_fields_needed
            let _ = fields.map { (unwrappedOptionalArray) -> Void in
                // if array has values
                if !unwrappedOptionalArray.isEmpty {
                    // print("checking if empty... false")
                    completionHandler(false, nil)
                } else {
                    // print("checking if empty... true")
                    completionHandler(true, nil)
                }
            }
        }
    }
    
    func refresh(sender:AnyObject) {
        self.configureView()
        self.validateAccount()
        self.loadProfile()
        self.configureHeader()
//        self.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 220));
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 180))
        self.view.sendSubviewToBack(self.tableView.tableHeaderView!)
        let _ = Timeout(0.3) {
            self.refreshControlView.endRefreshing()
        }
    }
    
    func configureView() {
        
        self.view.backgroundColor = UIColor.clearColor()
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height

        self.view.bringSubviewToFront(tableView)
//        self.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 220));
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 180))
        
        refreshControlView.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControlView.addTarget(self, action: #selector(ProfileMenuViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControlView) // not required when using UITableViewController

        configureHeader()
        
        loadProfile()
        
        // Add action to share cell to return to activity menu
        shareCell.targetForAction(Selector("share:"), withSender: self)
        
        // Add action to rate cell to return to activity menu
        let rateGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openStoreProductWithiTunesItemIdentifier(_:)))
        rateCell.addGestureRecognizer(rateGesture)
        
        // Add action to invite user
        let inviteGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.inviteUser(_:)))
        inviteCell.addGestureRecognizer(inviteGesture)
        
        maskHeaderView.frame = CGRect(x: 0, y: 90, width: screenWidth, height: 60)
        maskHeaderView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(maskHeaderView)
        menuSegmentBar.addTarget(self, action: #selector(self.toggleSegment(_:)), forControlEvents: .ValueChanged)
        menuSegmentBar.selectedSegmentIndex = 0
        menuSegmentBar.frame = CGRect(x: 30, y: 120, width: screenWidth-60, height: 30)
        self.view.addSubview(menuSegmentBar)
        self.view.bringSubviewToFront(menuSegmentBar)
    }
    
    func inviteUser(sender: AnyObject) {
        self.presentViewController(AddCustomerViewController(), animated: true, completion: nil)
    }
    
    func openStoreProductWithiTunesItemIdentifier(sender: AnyObject) {
        showGlobalNotification("Loading App Store", duration: 1, inStyle: CWNotificationAnimationStyle.Top, outStyle: CWNotificationAnimationStyle.Top, notificationStyle: CWNotificationStyle.NavigationBarNotification, color: UIColor.pastelBlue())
        
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
        
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "IconPinWhiteTiny")
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        Account.getStripeAccount { (acct, err) in
            self.checkIfVerified({ (bool, err) in
                if bool == true {
                    // the account does not require information, display location
                    if let address_city = acct?.address_city where address_city != "", let address_country = acct?.address_country {
                        let locationStr = adjustAttributedStringNoLineSpacing(address_city.uppercaseString + ", " + address_country.uppercaseString, spacing: 0.5, fontName: "SFUIText-Regular", fontSize: 11, fontColor: UIColor.darkBlue())
                        // locationStr.appendAttributedString(attachmentString)
                        self.locationLabel.attributedText = locationStr
                    } else {
                        let locationStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
                        locationStr.appendAttributedString(attachmentString)
                        self.locationLabel.attributedText = locationStr
                    }
                    self.view.addSubview(self.locationLabel)
                } else {
                    // profile information is required, show tutorial button
                }
            })
        }
        self.locationLabel.frame = CGRectMake(0, 62, screenWidth, 70)
        self.locationLabel.textAlignment = NSTextAlignment.Center
        self.locationLabel.font = UIFont(name: "SFUIText-Regular", size: 12)
        self.locationLabel.numberOfLines = 0
        self.locationLabel.textColor = UIColor.darkBlue()
        
    }
    
    // Sets up nav
    func configureNav(user: User) {
        let navItem = UINavigationItem()

        // TODO: do a check for first name, and business name
        let f_name = user.first_name
        let l_name = user.last_name
        let u_name = user.username
        let b_name = user.business_name
        if b_name != "" {
            navItem.title = b_name
        } else if f_name != "" {
            navItem.title = f_name + " " + l_name
        } else {
            navItem.title = u_name
        }
        
        self.navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.darkBlue(),
            NSFontAttributeName : UIFont(name: "SFUIText-Regular", size: 17.0)!
        ]
        self.navBar.setItems([navItem], animated: false)
        let _ = Timeout(0.1) {
            self.view.addSubview(self.navBar)
        }
    }
    
    //Changing Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
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
                // let sb = UIStoryboard(name: "Main", bundle: nil)
                // let loginVC = sb.instantiateViewControllerWithIdentifier("LoginViewController")
                // loginVC.modalTransitionStyle = .CrossDissolve
                // let root = UIApplication.sharedApplication().keyWindow?.rootViewController
                // root!.presentViewController(loginVC, animated: true, completion: { () -> Void in })
                self.performSegueWithIdentifier("loginView", sender: self)
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
            
            let acv = UIActivityIndicatorView(activityIndicatorStyle: .White)
            acv.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            acv.startAnimating()
            self.activityIndicator.center = self.userImageView.center
            self.userImageView.addSubview(acv)
            addActivityIndicatorView(acv, view: self.userImageView, color: .White)
            self.userImageView.bringSubviewToFront(acv)
            
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
                let img = UIImage(named: "IconAnonymous")
                self.userImageView.image = img
                addSubviewWithFade(self.userImageView, parentView: self, duration: 0.8)
            }
        })
        
    }
    
    // Opens edit picture
    func goToEditPicture(sender: AnyObject) {
        self.performSegueWithIdentifier("profilePictureView", sender: sender)
    }
    
    // Opens edit picture
    func goToEdit(sender: AnyObject) {
        self.performSegueWithIdentifier("editProfileView", sender: sender)
    }
    
}

extension ProfileMenuViewController {
    // MARK: Tutorial modal
    
    func showTutorialModal(sender: AnyObject) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("accountVerificationModalNavigationController") as! UINavigationController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
        
        // Initialize and style the terms and conditions modal
        formSheetController.presentationController?.contentViewSize = CGSizeMake(300, UIScreen.mainScreen().bounds.height-130)
        formSheetController.presentationController?.shouldUseMotionEffect = true
        formSheetController.presentationController?.containerView?.backgroundColor = UIColor.blackColor()
        formSheetController.presentationController?.containerView?.sizeToFit()
        formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
        formSheetController.presentationController?.blurEffectStyle = UIBlurEffectStyle.Dark
        formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
        formSheetController.presentationController?.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppears.CenterVertically
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldCenterHorizontally = true
        formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyle.SlideFromBottom
        formSheetController.contentViewCornerRadius = 15
        formSheetController.allowDismissByPanningPresentedView = true
        formSheetController.interactivePanGestureDismissalDirection = .All;
        
        // Blur will be applied to all MZFormSheetPresentationControllers by default
        MZFormSheetPresentationController.appearance().shouldApplyBackgroundBlurEffect = true
        
        let presentedViewController = navigationController.viewControllers.first as! AccountVerificationTutorialViewController
        
        // keep passing along user data to modal
        presentedViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        presentedViewController.navigationItem.leftItemsSupplementBackButton = true
        
        // Be sure to update current module on storyboard
        self.presentViewController(formSheetController, animated: true, completion: nil)
    }
}

extension ProfileMenuViewController {
    func toggleSegment(sender: UISegmentedControl) {
        self.tableView.beginUpdates()
        //  change boolean conditions for what to show/hide
        if menuSegmentBar.selectedSegmentIndex == 0 {
            self.view.bringSubviewToFront(menuSegmentBar)
            self.view.bringSubviewToFront(verifiedLabel)
            self.shouldShowSection1 = true
            self.shouldShowSection2 = false
        } else if menuSegmentBar.selectedSegmentIndex == 1 {
            self.view.bringSubviewToFront(menuSegmentBar)
            self.view.bringSubviewToFront(verifiedLabel)
            self.shouldShowSection1 = false
            self.shouldShowSection2 = true
        }
        self.tableView.endUpdates()
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.shouldShowSection1 == true {
                return 44.0
            } else {
                return 0.0
            }
        }
        else if indexPath.section == 1 {
            if self.shouldShowSection2 == true {
                return 44.0
            } else {
                return 0.0
            }
        } else {
            return 44.0
        }
    }
}

extension ProfileMenuViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y > 90 {
            self.view.bringSubviewToFront(menuSegmentBar)
            self.menuSegmentBar.frame.origin.y = self.tableView.contentOffset.y+30
            self.maskHeaderView.frame.origin.y = self.tableView.contentOffset.y+20
        }
    }
}

