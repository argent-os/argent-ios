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

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label

class ProfileMenuViewController: UITableViewController {
    
    @IBOutlet weak var shareCell: UITableViewCell!

    private var userImageView: UIImageView = UIImageView()

    private var scrollView: UIScrollView!

    private var notification = CWStatusBarNotification()

    private let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.mainScreen().bounds.size.width, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        showProfileIncompleteStatusNotification()
        configureView()
    }

    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        self.view.bringSubviewToFront(tableView)
        self.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 100));
        
        userImageView.frame = CGRectMake(screenWidth / 2, -64, 32, 32)
    
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.frame = CGRect(x: 0, y: 100, width: screenWidth, height: 100)
        loadingView.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
                self!.loadProfile()
                self!.userImageView.frame = CGRectMake(screenWidth / 2-30, -24, 60, 60)
                self!.userImageView.layer.cornerRadius = 30
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.clearColor())
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.clearColor())
        
        loadProfile()
        
        // Add action to share cell to return to activity menu
        shareCell.targetForAction(Selector("share:"), withSender: self)
    }

    func configureNav(user: User) {
        let navItem = UINavigationItem()

        // TODO: do a check for first name, and business name
        let f_name = user.first_name
        let l_name = user.last_name
        navItem.title = f_name + " " + l_name
        
        self.navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Avenir-Light", size: 16.0)!
        ]
        self.navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func showProfileIncompleteStatusNotification() {
        setupIncompleteNotification()
        notification.displayNotificationWithMessage("Profile Incomplete", forDuration: 2.5)
    }
    
    func showProfileCompleteStatusNotification() {
        setupCompleteNotification()
        notification.displayNotificationWithMessage("Profile Complete!", forDuration: 2.5)
    }
    
    func setupCompleteNotification() {
        let inStyle = CWNotificationAnimationStyle.Left
        let outStyle = CWNotificationAnimationStyle.Right
        let notificationStyle = CWNotificationStyle.StatusBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor.brandGreen()
        self.notification.notificationAnimationInStyle = inStyle
        self.notification.notificationAnimationOutStyle = outStyle
        self.notification.notificationStyle = notificationStyle
    }
    
    
    func setupIncompleteNotification() {
        let inStyle = CWNotificationAnimationStyle.Left
        let outStyle = CWNotificationAnimationStyle.Right
        let notificationStyle = CWNotificationStyle.StatusBarNotification
        self.notification.notificationLabelBackgroundColor = UIColor.brandYellow()
        self.notification.notificationAnimationInStyle = inStyle
        self.notification.notificationAnimationOutStyle = outStyle
        self.notification.notificationStyle = notificationStyle
    }
    
    override func viewDidAppear(animated: Bool) {
        UIStatusBarStyle.Default
    }
    
    //Changing Status Bar
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)!.tag == 865) {
            let activityViewController  = UIActivityViewController(
                activityItems: ["Check out this app!  http://www.argentapp.com/home" as NSString],
                applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            presentViewController(activityViewController, animated: true, completion: nil)
        }
        if(tableView.cellForRowAtIndexPath(indexPath)!.tag == 534) {
            // 1
            let optionMenu = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .ActionSheet)
            // 2
            let logoutAction = UIAlertAction(title: "Logout", style: .Destructive, handler: {
                (alert: UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().setBool(false,forKey:"userLoggedIn");
                NSUserDefaults.standardUserDefaults().synchronize();
                // go to login view
                self.performSegueWithIdentifier("loginView", sender: self);
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
    
    func addSubviewWithBounce(imageView: UIImageView) {
        imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
        self.view.addSubview(imageView)
        UIView.animateWithDuration(0.3 / 1.5, animations: {() -> Void in
            imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            }, completion: {(finished: Bool) -> Void in
                UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
                    }, completion: {(finished: Bool) -> Void in
                        UIView.animateWithDuration(0.3 / 2, animations: {() -> Void in
                            imageView.transform = CGAffineTransformIdentity
                        })
                })
        })
    }
    
    func loadProfile() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileMenuViewController.goToEditPicture(_:)))
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 120)
        userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor(rgba: "#fff").CGColor
        
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
                self.addSubviewWithBounce(self.userImageView)
            } else {
                let img = UIImage(named: "IconCamera")
                self.userImageView.image = img
                self.addSubviewWithBounce(self.userImageView)
            }
        })
    }
    
    func goToEditPicture(sender: AnyObject) {
        self.performSegueWithIdentifier("profilePictureView", sender: sender)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
        headerView.scrollViewDidScroll(scrollView)
        
        let offsetY = scrollView.contentOffset.y
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
                
        if offsetY < 0 && offsetY > -80 && userImageView.frame.size.width > 16 {
            userImageView.layer.cornerRadius = (userImageView.frame.size.width/2)
            userImageView.frame = CGRect(x: screenWidth/2-(-offsetY)/2, y: -24, width: -offsetY, height: -offsetY)
        } else if offsetY < 0 {
            userImageView.layer.cornerRadius = (userImageView.frame.size.width/2)
            userImageView.frame = CGRect(x: screenWidth/2-(-offsetY)/2, y: -24, width: -offsetY, height: -offsetY)
        }
    }
}