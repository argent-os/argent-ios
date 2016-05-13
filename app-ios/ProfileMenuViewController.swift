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

class ProfileMenuViewController: UITableViewController {
    
    @IBOutlet weak var shareCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width

        self.tableView.tableHeaderView = ParallaxHeaderView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100));
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: 100)
        loadingView.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
                self!.loadProfile()
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.clearColor())
        tableView.dg_setPullToRefreshBackgroundColor(UIColor.clearColor())
        
        loadProfile()
        
        // Add action to share cell to return to activity menu
        shareCell.targetForAction(Selector("share:"), withSender: self)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
        headerView.scrollViewDidScroll(scrollView)
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
    
    func loadProfile() {
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let userImageView: UIImageView = UIImageView(frame: CGRectMake(screenWidth / 2, 0, 90, 90))
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ProfileMenuViewController.goToEditPicture(_:)))
        userImageView.userInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        
        User.getProfile({ (user, error) in
            
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load profile \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            if user?.picture != nil && user?.picture != "" {
                let img = UIImage(data: NSData(contentsOfURL: NSURL(string: (user?.picture)!)!)!)!
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 120)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 3
                userImageView.layer.borderColor = UIColor(rgba: "#fff").CGColor
                self.tableView.addSubview(userImageView)
            } else {
                let img = UIImage(named: "IconCamera")
                let userImageView: UIImageView = UIImageView(frame: CGRectMake(screenWidth / 2, 0, 90, 90))
                userImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
                userImageView.center = CGPointMake(self.view.bounds.size.width / 2, 120)
                userImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                userImageView.layer.cornerRadius = userImageView.frame.size.height/2
                userImageView.layer.masksToBounds = true
                userImageView.clipsToBounds = true
                userImageView.image = img
                userImageView.layer.borderWidth = 3
                userImageView.layer.borderColor = UIColor(rgba: "#fff").CGColor
                self.tableView.addSubview(userImageView)
            }
        })
    }
    
    func goToEditPicture(sender: AnyObject) {
        self.performSegueWithIdentifier("profilePictureView", sender: sender)
    }
    
}