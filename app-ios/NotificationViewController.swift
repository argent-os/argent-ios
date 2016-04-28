//
//  NotificationViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemsArray:Array<NotificationItem>?
    @IBOutlet var tableView: UITableView?
    
    var refreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.darkGrayColor()
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.refreshControl.backgroundColor = UIColor.clearColor()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(NotificationsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.addSubview(refreshControl)
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 15, width: screenWidth, height: 50))
        navBar.barTintColor = UIColor(rgba: "#FFF")
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.darkGrayColor(),
            NSFontAttributeName : UIFont(name: "Helvetica", size: 18)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Notifications");
        navBar.setItems([navItem], animated: false);
        
        self.loadNotificationItems()
    }
    
    func loadNotificationItems() {
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.ExtraLight)
        HUD.showInView(self.view!)
        NotificationItem.getNotificationList({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load notifications \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = items?.reverse()
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.refreshControl.refreshing
            {
                self.refreshControl.endRefreshing()
            }
            HUD.dismiss()

            self.tableView?.reloadData()
        })
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadNotificationItems()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = self.itemsArray?[indexPath.row]
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        if let text = item?.text
        {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 16)
            cell.textLabel?.textColor = UIColor.darkGrayColor()
            cell.textLabel?.text = text
        }
        if let date = item?.date, uid = item?.uid
        {
            if(!date.isEmpty || date != "") {
                let converted_date = NSDate(timeIntervalSince1970: Double(date)!)
                dateFormatter.timeStyle = .MediumStyle
                let formatted_date = dateFormatter.stringFromDate(converted_date)
                cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 12)
                cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
                cell.detailTextLabel?.text = String(formatted_date) //+ " / uid " + uid
            } else {
                print("no date")
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
}
