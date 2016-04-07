//
//  CreditCardListViewController.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 4/7/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JGProgressHUD
import SESlideTableViewCell

class CreditCardListViewController: UITableViewController, SESlideTableViewCellDelegate {
    
    var itemsArray:Array<Card>?
    var cardRefreshControl = UIRefreshControl()
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Credit Cards"
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        
        let HUD: JGProgressHUD = JGProgressHUD.init(style: JGProgressHUDStyle.Dark)
        HUD.showInView(self.view!)
        HUD.textLabel.text = "Loading Credit Cards"
        HUD.dismissAfterDelay(0.7)
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        
        self.cardRefreshControl.backgroundColor = UIColor.clearColor()
        
        self.cardRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.cardRefreshControl.addTarget(self, action: #selector(CreditCardListViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(cardRefreshControl)
        
        self.loadCreditCards()
    }
    
    func loadCreditCards() {
        Card.getCreditCards({ (items, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: "Could not load credit cards \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.itemsArray = items
            
            // update "last updated" title for refresh control
            let now = NSDate()
            let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
            self.cardRefreshControl.attributedTitle = NSAttributedString(string: updateString)
            if self.cardRefreshControl.refreshing
            {
                self.cardRefreshControl.endRefreshing()
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
    
    func refresh(sender:AnyObject)
    {
        self.loadCreditCards()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CELL_ID = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as? SESlideTableViewCell
        if (cell == nil) {
            cell = SESlideTableViewCell(style: .Subtitle, reuseIdentifier: CELL_ID)
            cell!.delegate = self
            cell!.addRightButtonWithText("Delete", textColor: UIColor.whiteColor(), backgroundColor: UIColor(hue: 0.0/360.0, saturation: 0.8, brightness: 0.9, alpha: 1.0))
            let item = self.itemsArray?[indexPath.row]
            cell!.textLabel?.text = ""
            cell!.detailTextLabel?.text = ""
            if let brand = item?.brand
            {
                cell!.textLabel?.text = brand
            }
            if let number = item?.last4
            {
                cell!.detailTextLabel?.text = "For card ending in " + number
                
            }
        }
        
        return cell!
    }
    
}
