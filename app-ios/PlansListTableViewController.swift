//
//  PlansListTableViewController.swift
//  app-ios
//
//  Created by Sinan Ulkuatam on 6/1/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CWStatusBarNotification
import MCSwipeTableViewCell
import DZNEmptyDataSet

class PlansListTableViewController: UITableViewController, MCSwipeTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UINavigationBarDelegate  {
    
    var navigationBar = UINavigationBar()
    
    var itemsArray:Array<Plan>?
    
    var viewRefreshControl = UIRefreshControl()
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupNav()
    }
    
    private func configureView() {
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        let _ = Timeout(1.2) {
            activityIndicator.stopAnimating()
        }
        
        self.navigationItem.title = "Plans"
        self.navigationController?.navigationBar.tintColor = UIColor.lightBlue()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.viewRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.viewRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.viewRefreshControl.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(viewRefreshControl)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // trick to make table lines disappear
        self.tableView.tableFooterView = UIView()
        
        self.loadPlanList()
        
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        //let screenHeight = screen.size.height
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.offWhite()
        headerView.frame = CGRect(x: 0, y: 10, width: screenWidth, height: 60)
        self.tableView.tableHeaderView = headerView
        let headerViewTitle: UILabel = UILabel()
        headerViewTitle.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 35)
        headerViewTitle.text = "Plans"
        headerViewTitle.font = UIFont.systemFontOfSize(16)
        headerViewTitle.textAlignment = .Center
        headerViewTitle.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.7)
        headerView.addSubview(headerViewTitle)
        
        self.tableView.separatorColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
    }
    
    private func setupNav() {
        // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60)
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.tintColor = UIColor.lightBlue()
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = ""
        
        // Create left and right button for navigation item
        let leftButton = UIBarButtonItem(image: UIImage(named: "IconClose"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChargeViewController.returnToMenu(_:)))
        let font = UIFont(name: "DINAlternate-Bold", size: 14)
        leftButton.setTitleTextAttributes([NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.mediumBlue()], forState: UIControlState.Normal)
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.titleTextAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName:UIColor.lightBlue()]
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func loadPlanList() {
        Plan.getPlanList({ (plans, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load plans \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = plans
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.viewRefreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.viewRefreshControl.refreshing
            {
                self.viewRefreshControl.endRefreshing()
            }
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
    
    func refresh(sender:AnyObject) {
        self.loadPlanList()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }
    
    // MARK DELEGATE MCTABLEVIEWCELL
    
    func viewWithImageName(name: String) -> UIView {
        let image: UIImage = UIImage(named: name)!;
        let imageView: UIImageView = UIImageView(image: image);
        imageView.contentMode = UIViewContentMode.Center;
        return imageView;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier: String = "cell";
        var cell: MCSwipeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MCSwipeTableViewCell!;
        cell = MCSwipeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier);
        cell!.selectionStyle = UITableViewCellSelectionStyle.Gray;
        cell!.contentView.backgroundColor = UIColor.whiteColor();
        cell.textLabel?.tintColor = UIColor.lightBlue()
        cell.detailTextLabel?.tintColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
        cell.tag = indexPath.row
        
        let item = self.itemsArray?[indexPath.row]
        if let name = item?.name {
            let strName = name
            cell.textLabel?.attributedText = NSAttributedString(string: strName + " ", attributes: [
                NSForegroundColorAttributeName : UIColor.mediumBlue(),
                NSFontAttributeName : UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
                ])
        }
        if let amount = item?.amount, interval = item?.interval {
            let intervalAttributedString = NSAttributedString(string: interval, attributes: [
                NSForegroundColorAttributeName : UIColor.lightBlue().colorWithAlphaComponent(0.5),
                NSFontAttributeName : UIFont.systemFontOfSize(11, weight: UIFontWeightRegular)
                ])
            let attrText = formatCurrency(String(amount), fontName: "HelveticaNeue", superSize: 11, fontSize: 15, offsetSymbol: 2, offsetCents: 2) +  NSAttributedString(string: " per ") + intervalAttributedString
            cell.detailTextLabel?.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
            cell.detailTextLabel?.attributedText = attrText
            
        }
    
        let closeView: UIView = self.viewWithImageName("ic_close_light");
        
        cell.setSwipeGestureWithView(closeView, color:  UIColor.brandRed(), mode: .Exit, state: .State3) {
            (cell : MCSwipeTableViewCell!, state : MCSwipeTableViewCellState!, mode : MCSwipeTableViewCellMode!) in
            let item = self.itemsArray?[cell.tag]
            if let id = item?.id {
                print("Did swipe" + id);
                // send request to delete, on completion reload table data!
                let alertController = UIAlertController(title: "Confirm deletion", message: "Are you sure?  This action cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Continue", style: .Default) { (action) in
                    // send request to delete, on completion reload table data!
                    Plan.deletePlan(id, completionHandler: { (bool, err) in
                        print("deleted plan ", bool)
                        self.loadPlanList()
                        self.tableView?.reloadData()
                    })
                }
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        };
        
        return cell;
    }
    
    func returnToMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { }
    }
    
}



extension PlansListTableViewController {
    // Delegate: DZNEmptyDataSet
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Plans"
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No plans to show."
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmpty")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = "Create a plan"
        // let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RecurringBillingViewController") as! RecurringBillingViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

