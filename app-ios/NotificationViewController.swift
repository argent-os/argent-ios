//
//  NotificationViewController.swift
//  argent-ios
//
//  Created by Sinan Ulkuatam on 3/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DGElasticPullToRefresh
import DZNEmptyDataSet
import CellAnimator

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private var notificationsArray:Array<NotificationItem>?
    
    private var tableView:UITableView = UITableView()
    
    private var dateFormatter = NSDateFormatter()
    
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidAppear(animated: Bool) {
        self.childViewControllerForStatusBarStyle()?.setNeedsStatusBarAppearanceUpdate()
        if notificationsArray?.count == 0 {
            self.loadNotificationItems("100", starting_after: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addInfiniteScroll()
    }
    
    private func addInfiniteScroll() {
        // Add infinite scroll handler
        // change indicator view style to white
        self.tableView.infiniteScrollIndicatorStyle = .Gray
        
        // Remove extra splitters in table
        self.tableView.tableFooterView = UIView()
        
        // Add infinite scroll handler
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            //
            // fetch your data here, can be async operation,
            // just make sure to call finishInfiniteScroll in the end
            //
            if self.notificationsArray!.count > 0 {
                let lastIndex = NSIndexPath(forRow: self.notificationsArray!.count - 1, inSection: 0)
                let id = self.notificationsArray![lastIndex.row].id
                // fetch more data with the id
                self.loadNotificationItems("100", starting_after: id)
            }
            
            // make sure you reload tableView before calling -finishInfiniteScroll
            tableView.reloadData()
            
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    private func configureView() {
        let screen = UIScreen.mainScreen().bounds
        let screenWidth = screen.size.width
        let screenHeight = screen.size.height
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.lightBlue().colorWithAlphaComponent(0.3)
        tableView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-110)
        self.view.addSubview(tableView)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.frame = CGRect(x: 0, y: 65, width: screenWidth, height: 100)
        loadingView.tintColor = UIColor.whiteColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self?.tableView.dg_stopLoading()
                self!.loadNotificationItems("100", starting_after: "")
            })
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor.seaBlue())
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        navBar.barTintColor = UIColor.oceanBlue()
        navBar.tintColor = UIColor.whiteColor()
        navBar.translucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 17)!
        ]
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Notifications");
        navBar.setItems([navItem], animated: false);
        
        self.loadNotificationItems("100", starting_after: "")

    }
    
    private func loadNotificationItems(limit: String, starting_after: String) {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        NotificationItem.getNotificationList(limit, starting_after: starting_after, completionHandler: { (notifications, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load notifications \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.notificationsArray = notifications
            
            self.activityIndicator.stopAnimating()
            
            // sets empty data set if data is nil
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        })
    }
    
    private func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    private func dayStringFromTime(unixTime: Double) -> String {
        let dateFormatter = NSDateFormatter()
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
    private func refresh(sender:AnyObject) {
        self.loadNotificationItems("100", starting_after: "")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationsArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let CellIdentifier: String = "Cell"
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellIdentifier)
        
        CellAnimator.animateCell(cell, withTransform: CellAnimator.TransformTilt, andDuration: 0.3)

        let item = self.notificationsArray?[indexPath.row]
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        if let text = item?.type {
            switch text {
                case "invoice.created":
                    cell.textLabel?.text = "Invoice Created"
                case "account.updated":
                    cell.textLabel?.text = "Account updated"
                case "account.external_account.created":
                    cell.textLabel?.text = "External account created"
                case "account.external_account.updated":
                    cell.textLabel?.text = "External account updated"
                case "account.external_account.deleted":
                    cell.textLabel?.text = "External account deleted"
                case "account.application.deauthorized":
                    cell.textLabel?.text = "Account application deauthorized"
                case "application_fee.created":
                    cell.textLabel?.text = "Application fee created"
                case "application_fee.refunded":
                    cell.textLabel?.text = "Application fee refunded"
                case "balance.available":
                    cell.textLabel?.text = "Your account balance is now available"
                case "charge.pending":
                    cell.textLabel?.text = "Charge pending"
                case "charge.succeeded":
                   cell.textLabel?.text = "Charge succeeded"
                case "charge.failed":
                   cell.textLabel?.text = "Charge failed"
                case "charge.refunded":
                   cell.textLabel?.text = "Charge refunded"
                case "charge.captured":
                   cell.textLabel?.text = "Charge captured"
                case "charge.updated":
                   cell.textLabel?.text = "Charge updated"
                case "charge.dispute.created":
                   cell.textLabel?.text = "Charge dispute created"
                case "charge.dispute.updated":
                   cell.textLabel?.text = "Charge dispute updated"
                case "charge.dispute.closed":
                   cell.textLabel?.text = "Charge dispute is now closed"
                case "customer.created":
                   cell.textLabel?.text = "New customer created"
                case "customer.updated":
                   cell.textLabel?.text = "Customer information updated"
                case "customer.deleted":
                   cell.textLabel?.text = "Customer deleted"
                case "customer.card.created":
                   cell.textLabel?.text = "Customer card added"
                case "customer.card.updated":
                   cell.textLabel?.text = "Customer card information updated"
                case "customer.card.deleted":
                   cell.textLabel?.text = "Customer card deleted"
                case "customer.subscription.created":
                   cell.textLabel?.text = "Customer subscription created"
                case "customer.subscription.updated":
                   cell.textLabel?.text = "Customer subscription updated"
                case "customer.subscription.deleted":
                   cell.textLabel?.text = "Customer subscription deleted"
                case "customer.subscription.trial_will_end":
                   cell.textLabel?.text = "Customer subscription trial will end soon"
                case "customer.discount.created":
                   cell.textLabel?.text = "Customer discount created"
                case "customer.discount.updated":
                   cell.textLabel?.text = "Customer discount updated"
                case "customer.discount.deleted":
                   cell.textLabel?.text = "Customer discount deleted"
                case "customer.source.created":
                    cell.textLabel?.text = "Customer source created"
                case "customer.source.updated":
                    cell.textLabel?.text = "Customer source updated"
                case "customer.source.deleted":
                    cell.textLabel?.text = "Customer source deleted"
                case "invoice.created":
                   cell.textLabel?.text = "Invoice created"
                case "invoice.updated":
                   cell.textLabel?.text = "Invoice updated"
                case "invoice.payment_succeeded":
                   cell.textLabel?.text = "Invoice payment succeeded"
                case "invoice.payment_failed ":
                   cell.textLabel?.text = "Invoice payment failed"
                case "payment.created ":
                    cell.textLabel?.text = "Payment Created"
                case "payment.failed ":
                    cell.textLabel?.text = "Payment failed"
                case "payment.updated ":
                    cell.textLabel?.text = "Payment updated"
                case "invoiceitem.created":
                   cell.textLabel?.text = "Invoice item created"
                case "invoiceitem.updated":
                   cell.textLabel?.text = "Invoice item updated"
                case "invoiceitem.deleted":
                   cell.textLabel?.text = "Invoice item deleted"
                case "plan.created":
                   cell.textLabel?.text = "Recurring billing plan created"
                case "plan.updated":
                   cell.textLabel?.text = "Recurring billing plan updated"
                case "plan.deleted":
                   cell.textLabel?.text = "Recurring billing plan deleted"
                case "coupon.created":
                   cell.textLabel?.text = "Coupon created"
                case "coupon.deleted":
                   cell.textLabel?.text = "Coupon deleted"
                case "recipient.created":
                   cell.textLabel?.text = "Recipient created"
                case "recipient.updated":
                   cell.textLabel?.text = "Recipient information updated"
                case "recipient.deleted":
                   cell.textLabel?.text = "Recipient deleted"
                case "transfer.created":
                   cell.textLabel?.text = "Transfer created"
                case "transfer.updated":
                   cell.textLabel?.text = "Transfer updated"
                case "transfer.paid":
                   cell.textLabel?.text = "Transfer paid successfully"
                case "transfer.failed":
                   cell.textLabel?.text = "Transfer failed"
                case "bitcoin.receiver.transaction.created":
                    cell.textLabel?.text = "Bitcoin receiver transaction created"
                case "bitcoin.receiver.created":
                    cell.textLabel?.text = "Bitcoin receiver created"
                case "bitcoin.receiver.filled":
                    cell.textLabel?.text = "Bitcoin receiver filled"
                default:
                    cell.textLabel?.text = text
            }
            cell.textLabel?.font = UIFont(name: "MyriadPro-Regular", size: 14)!
            cell.textLabel?.textColor = UIColor.lightBlue()
        }
        if let date = item?.created
        {
            if(!date.isEmpty || date != "") {
                let converted_date = NSDate(timeIntervalSince1970: Double(date)!)
                dateFormatter.timeStyle = .MediumStyle
                let formatted_date = dateFormatter.stringFromDate(converted_date)
                cell.detailTextLabel?.font = UIFont(name: "MyriadPro-Regular", size: 11)!
                cell.detailTextLabel?.textColor = UIColor.lightBlue().colorWithAlphaComponent(0.5)
                cell.detailTextLabel?.text = String(formatted_date) //+ " / uid " + uid
            } else {

            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

extension NotificationsViewController {
    // Delegate: DZNEmptyDataSet
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Notifications"
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: headerAttrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Events and push notifications will appear here as they occur."
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: bodyAttrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "IconEmptyNotifications")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        // let str = "Turn on push notifications"
        let str = ""
        //let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCallout)]
        return NSAttributedString(string: str, attributes: calloutAttrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ConfigureNotificationsViewController") as! ConfigureNotificationsViewController
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}
