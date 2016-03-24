//
//  ProfileMenuViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/19/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SafariServices

class ProfileMenuViewController: UITableViewController {
    
    @IBOutlet weak var shareCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add action to share cell to return to activity menu
        shareCell.targetForAction("share:", withSender: self)
        
        print("loaded profile menu")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected cell \(indexPath.row)")
        if(tableView.cellForRowAtIndexPath(indexPath)!.tag == 865) {
            let activityViewController  = UIActivityViewController(
                activityItems: ["Check out this app!  http://www.protonpayments.com/home" as NSString],
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
                print("Cancelled")
            })
            // 4
            optionMenu.addAction(logoutAction)
            optionMenu.addAction(cancelAction)
            // 5
            self.presentViewController(optionMenu, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "termsView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "http://www.protonpayments.com/home")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.protonpayments.com/home")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            if identifier == "privacyView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "http://www.protonpayments.com/home")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.protonpayments.com/home")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            if identifier == "supportView" {
                if #available(iOS 9.0, *) {
                    let svc = SFSafariViewController(URL: NSURL(string: "http://www.protonpayments.com/home")!, entersReaderIfAvailable: true)
                    self.presentViewController(svc, animated: true, completion: nil)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.protonpayments.com/home")!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
}